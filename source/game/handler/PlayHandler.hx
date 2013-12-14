package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.common.LoopType;
import flaxen.component.Image;
import flaxen.component.Layer;
import flaxen.component.Offset;
import flaxen.component.Origin;
import flaxen.component.Scale;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.component.Tile;
import flaxen.component.ImageGrid;
import flaxen.component.Tween;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.util.ArrayUtil;
import flaxen.service.InputService;
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
			.add(new Image("art/background.png"))
			.add(Position.center())
			.add(Offset.center())
			.add(Origin.center())
			.add(new Rotation(0))
			.add(new Layer(100));

		newLevel();
	}

	override public function input(_)
	{
		var key = InputService.lastKey();
		if(key == Key.SPACE)
			newLevel();
		InputService.clearLastKey();
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
		randomizeLevel(2000);
		// f.addDependent(group, e);
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

	public function createObject(type:String, x:Int, y:Int, gridSize:Int)
	{
		var data = xml.elementsNamed(type).next();
		var size = Std.parseInt(data.get("size"));

		var e = f.newChildEntity("level", "levelObj")
			.add(new Image(data.get("image")))
			.add(new Position(x * gridSize, y * gridSize))
			.add(Origin.center())
			.add(new Layer(70));

		var r = Std.int(8 * Math.random()) * 45;
		e.add(new Rotation(r));

		if(type != ROBOT)
			e.add(new Scale(0.8, 0.8));

		if(gridSize != size)
			e.add(new Offset((gridSize - size) / 2, (gridSize - size) / 2));

		if(data.exists("tile"))
			e.add(new Tile(Std.parseInt(data.get("tile"))))
				.add(new ImageGrid(size, size));
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

