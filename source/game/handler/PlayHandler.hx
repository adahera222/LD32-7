package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.common.LoopType;
import flaxen.component.Image;
import flaxen.component.ImageGrid;
import flaxen.component.Layer;
import flaxen.component.Offset;
import flaxen.component.Origin;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.component.Scale;
import flaxen.component.Tile;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;
import flaxen.util.ArrayUtil;
import game.component.Explosion;
import game.component.Health;
import game.component.Guarding;
import game.component.ExplodesOnDeath;
import openfl.Assets;

class PlayHandler extends FlaxenHandler
{
	public static inline var XML_PATH:String = "data/game.xml";
	public static inline var BUNKER:String = "bunker";
	public static inline var STOCKPILE:String = "stockpile";
	public static inline var TRUCK:String = "truck";
	public static inline var ROBOT:String = "robot";
	public static inline var TENT:String = "tent";

	public var f:Flaxen;
	public var xml:Xml;
	public var fixedGrid:com.haxepunk.masks.Grid;

	public function new(f:Flaxen)
	{
		super();
		this.f = f;
	}

	override public function start(_)
	{
		var str:String = Assets.getText(XML_PATH);
		if(str == null)
			Log.error("Cannot load data " + XML_PATH);
		xml = Xml.parse(str).firstElement();

		var bomb = f.newSingleton("background")
			.add(new Image("art/background-debug.png"))
			.add(Position.center())
			.add(Offset.center())
			.add(Origin.center())
			.add(new Rotation(0))
			.add(new Layer(100));

		fixedGrid = new com.haxepunk.masks.Grid(600, 600, 20, 20, 10, 10); // 30x30 grid
		f.newSingleton("fixedGrid").add(fixedGrid);

		newLevel();
	}

	override public function input(_)
	{
		var key = InputService.lastKey();
		if(key == Key.SPACE)
			newLevel();
		InputService.clearLastKey();

		if(InputService.clicked)
		{
			var x = InputService.mouseX;
			var y = InputService.mouseY;
			f.newEntity("explosion")
				.add(new Position(x, y))
				.add(new Explosion(400));
		}
	}

	public function changeBackground()
	{
		var rot = f.demandEntity("background").get(Rotation);
		rot.angle += 90;
		if(rot.angle >= 360)
			rot.angle = 0;
	}

	public function newLevel()
	{
		var group = f.resetSingleton("level");
		changeBackground();	
		fixedGrid.clearRect(0, 0, 30, 30);	
		randomizeLevel(2000);
		// f.addDependent(group, e);
		trace("Fixed Grid:\n" + fixedGrid.saveToString(" ", "\n", "•", "·"));
	}

	public function randomizeLevel(totalPoints:Int)
	{
		var objects:Map<String,Int> = spendPoints(totalPoints); // Determine objects to place
		
		// Create an array of 5x5 grid positions for bunkers and stockpiles
		var bunkers = objects.get(BUNKER);
		var stockpiles = objects.get(STOCKPILE);
		var arr5 = new Array<Int>();
		for(i in 0...25)
			arr5.push(i);
		ArrayUtil.shuffle(arr5);
		for(i in 0...bunkers)
		{
			var pos = arr5.pop();
			createObject(BUNKER, pos % 5, Math.floor(pos / 5), 120);
		}
		for(i in 0...stockpiles)
		{
			var pos = arr5.pop();
			createObject(STOCKPILE, pos % 5, Math.floor(pos / 5), 120);
		}

		// Create an array of 10x10 grid positions, excluding those used for the 5x5 grid
		var arr10 = new Array<Int>();
		for(i in arr5)
		{
			var p = 2 * (Math.floor(i / 5) * 10 + (i % 5));
			arr10.push(p);
			arr10.push(p + 1);
			arr10.push(p + 10);
			arr10.push(p + 11);
		}
		ArrayUtil.shuffle(arr10);
		var tents = objects.get(TENT);
		var trucks = objects.get(TRUCK);
		for(i in 0...tents)
		{
			var pos = arr10.pop();
			createObject(TENT, pos % 10, Math.floor(pos / 10), 60);			
		}
		for(i in 0...trucks)
		{
			var pos = arr10.pop();
			createObject(TRUCK, pos % 10 , Math.floor(pos / 10), 60);			
		}

		// Create an array of 30x30 grid positions, excluding those used for the others
		var arr30 = new Array<Int>();
		for(i in arr10)
		{
			var p = 3 * (Math.floor(i / 10) * 30 + (i % 10));
			arr30.push(p);
			arr30.push(p + 1);
			arr30.push(p + 2);
			arr30.push(p + 30);
			arr30.push(p + 31);
			arr30.push(p + 32);
			arr30.push(p + 60);
			arr30.push(p + 61);
			arr30.push(p + 62);
		}
		ArrayUtil.shuffle(arr30);
		var robots = objects.get(ROBOT);
		for(i in 0...robots)
		{
			var pos = arr30.pop();
			createObject(ROBOT, pos % 30, Math.floor(pos / 30), 20);			
		}
	}

	public function createObject(type:String, x:Int, y:Int, cellSize:Int)
	{
		var data = xml.elementsNamed(type).next();
		var size = Std.parseInt(data.get("size"));

		var e = f.newChildEntity("level", "levelObj")
			.add(new Image(data.get("image")))
			.add(new Position((x + 0.5) * cellSize, (y + 0.5) * cellSize))
			.add(Offset.center())
			.add(Origin.center())
			.add(new Layer(70));

		var r = Std.int(8 * Math.random()) * 45;
		e.add(new Rotation(r));

		if(type != ROBOT)
			e.add(new Scale(0.7, 0.7));

		if(cellSize != size)
			// e.add(new Offset((cellSize - size) / 2, (cellSize - size) / 2));
			e.add(Offset.center());

		if(data.exists("tile"))
			e.add(new Tile(Std.parseInt(data.get("tile"))))
				.add(new ImageGrid(size, size));

		e.add(new ExplodesOnDeath(Std.parseInt(data.get("explosive"))))
			.add(new Health(Std.parseInt(data.get("hp"))));

		if(data.exists("patrols"))
			e.add(new Guarding(Math.random() * 6 - 3)); // start some out guarding for 1-3 sec, and others immediately patrol

		if(data.exists("fixed")) // mark this object on the fixed grid
		{
			var gs = Std.int(cellSize / 20);
			var gx = x * gs;
			var gy = y * gs;
			// trace("Adding object to:" + gx + "," + gy + " gs:" + gs + "x" + gs + " type:" + type +
			// 	" rawPos:" + x + "," + y + " cellSize:" + cellSize);
			fixedGrid.setRect(gx, gy, gs, gs, true);
		}			
	}

	public function spendPoints(points:Int): Map<String,Int>
	{
		if(points > 5000)
		{
			Log.warn("Hitting point cap:" + points);			
			points = 5000;
		}
		var map = new Map<String,Int>();
		for(obj in xml.get("objects").split(","))
			map.set(obj, 0);

		var totalSpent = 0;
		var buyOrder = xml.get("buyorder").split(",");
		var objFound:Bool = true;

		while(totalSpent < points && objFound)
		{
			objFound = false;
			for(name in buyOrder)
			{
				var obj = xml.elementsNamed(name).next();
				var cost:Int = Std.parseInt(obj.get("cost"));
				if(cost + totalSpent < points)
				{
					objFound = true;
					totalSpent += cost;
					map.set(name, map.get(name) + 1);
				}
			}
		}

		return map;
	}
}

