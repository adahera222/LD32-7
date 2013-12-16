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
import flaxen.component.Text;
import flaxen.component.Alpha;
import flaxen.component.Tween;
import flaxen.component.Animation;
import flaxen.component.Application;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;
import flaxen.util.ArrayUtil;
import flaxen.util.MathUtil;
import flaxen.util.StringUtil;
import game.component.ExplodesOnDeath;
import game.component.Explosion;
import game.component.AwardsPoints;
import game.component.Guarding;
import game.component.Health;
import game.component.Immobile;
import game.component.Traveler;
import game.component.Controls;
import game.component.Level;
import game.component.Busy;
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

		f.newSingleton("background")
			.add(new Image("art/background.png"))
			.add(Position.center())
			.add(Offset.center())
			.add(Origin.center())
			.add(new Rotation(0))
			.add(new Layer(100));

		fixedGrid = new com.haxepunk.masks.Grid(600, 600, 20, 20); // 30x30 grid
		fixedGrid.usePositions = true;
		f.newSingleton("fixedGrid").add(fixedGrid);

		for(obj in xml.get("objects").split(","))

		f.newComponentSet("robotTravelHealthy").add([Animation, "0-2", 15]).remove(Tile);
		f.newComponentSet("robotTravelHurt").add([Animation, "0-2", 15]).remove(Tile);
		f.newComponentSet("robotHealthy").add([Tile, 1]).remove(Animation);
		f.newComponentSet("robotHurt").add([Tile, 1]).remove(Animation);
		f.newComponentSet("robotRubble").add([Tile, 1]).remove(Animation);

		f.newComponentSet("truckTravelHealthy").add([Tile, 0]).remove(Animation);
		f.newComponentSet("truckTravelHurt").add([Tile, 0]).remove(Animation);
		f.newComponentSet("truckHealthy").add([Tile, 0]).remove(Animation);
		f.newComponentSet("truckHurt").add([Tile, 0]).remove(Animation);
		f.newComponentSet("truckRubble").add([Tile, 0]).remove(Animation);

		f.newComponentSet("bunkerHealthy").add([Tile, 0]).remove(Animation);
		f.newComponentSet("bunkerHurt").add([Tile, 0]).remove(Animation);
		f.newComponentSet("bunkerRubble").add([Tile, 0]).remove(Animation);

		f.newComponentSet("stockpileHealthy").add([Tile, 0]).remove(Animation);
		f.newComponentSet("stockpileHurt").add([Tile, 0]).remove(Animation);
		f.newComponentSet("stockpileRubble").add([Tile, 0]).remove(Animation);

		f.newComponentSet("tentHealthy").add([Tile, 0]).remove(Animation);
		f.newComponentSet("tentHurt").add([Tile, 0]).remove(Animation);
		f.newComponentSet("tentRubble").add([Tile, 0]).remove(Animation);

		var level = new Level();
		f.newSingleton("level").add(level);
		// level.value = 10; // HACK

		newLevel();
	}

	override public function input(_)
	{
		var key = InputService.lastKey();
		if(key == Key.TILDE) // HACK to redo level
			newLevel();
		#if !flash
		if(key == Key.TAB)
			flaxen.util.LogUtil.dumpLog(f.ash, "/Users/elund/Development/Jams/LD28/dump.txt");
		#end

		if(f.hasControl(CanBomb))
			checkBombDrop();

		if(f.hasControl(LevelComplete))
			checkNextLevel();

		InputService.clearLastKey();
	}

	public function checkNextLevel()
	{
		if(!InputService.clicked)
			return;

		f.removeControl(LevelComplete);

		var level = f.demandComponent("level", Level);
		if(level.success)
			nextLevel();
		else newLevel();
	}

	public function checkBombDrop()
	{
		if(!InputService.clicked)
			return;

		f.removeControl(CanBomb);
		var level = f.demandComponent("level", Level);
		var x = InputService.mouseX;
		var y = InputService.mouseY;
		var pos = new Position(x,y);
		var rot = Rotation.random();
		var scale = Scale.full();
		var bombTween = new Tween(rot, { angle:Rotation.random().angle }, 0.5);
		var bomb = f.newSingleton("bomb")
			.add(new Image("art/bomb.png"))
			.add(pos)
			.add(new Layer(15))
			.add(scale)
			.add(rot)
			.add(Origin.center())
			.add(Offset.center())
			.add(bombTween);
		f.newTween(scale, { x:0.1, y:0.1 }, 0.5);

		var explosion = f.newEntity("explosion", false)
			.add(pos)
			.add(Busy.instance)
			.add(new Explosion(400));

		f.newActionQueue()
			.waitForProperty(bombTween, "complete", true)
			.removeEntity(f.ash, bomb)
			.addEntity(f.ash, explosion)
			.addCallback(function()
			{ 
				level.dropped = true;
			});
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
		var group = f.resetSingleton("levelGroup");
		changeBackground();	
		fixedGrid.clearRect(0, 0, 600, 600);	

		var level = f.demandComponent("level", Level);
		level.reset();

		// Create new level with a target amount of points
		var desiredPoints = MathUtil.min(level.value * level.value * 25 + 5, 5000);
		randomizeLevel(desiredPoints); // will add to level.points
		// trace("Fixed Grid:\n" + fixedGrid.saveToString(" ", "\n", "•", "·"));

		// Set player target based on total points actually used (may be lower than points)
		level.target = Std.int(level.points * 0.65); // TODO Select difficulty

		// Add target score to upper right
		f.newChildSingleton("levelGroup", "targetText")
			.add(new Image("art/yellowNumberFont.png"))
			.add(Position.topRight().add(-5, 5))
			.add(new Layer(20))
			.add(new Text(StringUtil.formatCommas(level.target)))
			.add(TextStyle.createBitmap(false, Right, Top, 0, -2, 0, "2", false, "1234567890,"));

		levelIntro();
	}

	public function levelIntro()
	{
		var level = f.demandComponent("level", Level);
		var style = TextStyle.createBitmap(false, Center, Center, 0, -10, 0, "M", false, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
		var alpha = new Alpha(0);
		var scale = new Scale(10, 10);
		var t1 = f.newEntity()
			.add(new Image("art/giantFont.png"))
			.add(Position.center())
			.add(new Layer(18))
			.add(alpha)
			.add(scale)
			.add(style)
			.add(new Text(level.value <= 1 ? "BOMB THE ROBOT" : "BOMB THE ROBOTS"));
		f.newTween(alpha, { value:1.0 }, 1.0);
		var tween = f.newTween(scale, { x:0.8, y:0.8 }, 1.0);

		var t2 = f.newEntity()
			.add(new Image("art/redNumberFont.png"))
			.add(Position.bottom().add(0, -40))
			.add(new Layer(18))
			.add(alpha) // will fade
			.add(TextStyle.createBitmap(false, Right, Top, 0, -2, 0, "2", false, "1234567890,"))
			.add(new Text(Std.string(level.value)));

		f.newActionQueue()
			.waitForProperty(tween, "complete", true)
			.addCallback(function()
			{
				f.newSound("sound/getum.wav");
			})
			.addComponent(f.resolveEntity(Flaxen.CONTROL), CanBomb.instance)
			.delay(1.5)
			.removeEntity(f.ash, t1)
			.removeEntity(f.ash, t2);
	}

	public function nextLevel()
	{
		var level = f.demandComponent("level", Level);
		level.value++;
		newLevel();
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
		var size:Int = Std.parseInt(data.get("size"));
		var pos = new Position((x + 0.5) * cellSize, (y + 0.5) * cellSize);
		var e = f.newChildEntity("levelGroup", "levelObj")
			.add(new Image(data.get("image")))
			.add(pos)
			.add(Offset.center())
			.add(Origin.center())
			.add(new Layer(70));

		if(type != BUNKER)
		{
			var r = (type == STOCKPILE ? Math.random() * 360 : Std.int(8 * Math.random()) * 45);
			e.add(new Rotation(r));
		}

		if(type != ROBOT)
			e.add(new Scale(0.7, 0.7));

		if(cellSize != size)
			e.add(Offset.center());

		e.add(new ImageGrid(size, size));
		f.installComponents(e, type + "Healthy");

		e.add(new ExplodesOnDeath(Std.parseInt(data.get("explosive"))))
			.add(new Health(Std.parseInt(data.get("hp"))));

		if(data.exists("patrolSpeed"))
			e.add(new Guarding(Math.random() * 6 - 3)) // start some out guarding for 1-3 sec, and others immediately patrol
				.add((new Traveler(type, attr(data, "patrolSpeed", 0))));
		else e.add(new Immobile(type));

		if(data.exists("fixed")) // mark this object on the fixed grid, find upper left corner
			fixedGrid.setRect(Std.int(pos.x - size / 2), Std.int(pos.y - size / 2), size, size, true);

		var points:Int = attr(data, "points", 0);
		if(points > 0)
			e.add(new AwardsPoints(points));
		else throw("Zero points found for " + type + " data:" + data);

		var level = f.demandComponent("level", Level);
		level.count++;
		level.points += points;
	}

	public function attr<T>(data:Xml, name:String, def:T = null): T
	{
		if(!data.exists(name))
			return def;

		var result:Dynamic = data.get(name);

		if(Std.is(def, Int))
			return cast Std.parseInt(result);
			
		if(Std.is(def, Bool))
			return cast(result == "true" ? true : false);

		return result;			
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

		// map.set(STOCKPILE, 1);
		// return map;

		var totalSpent = 0;
		var buyOrder = xml.get("buyorder").split(",");
		var objFound:Bool = true;

		while(totalSpent < points && objFound)
		{
			objFound = false;
			for(name in buyOrder)
			{
				var obj = xml.elementsNamed(name).next();
				var cost:Int = Std.parseInt(obj.get("points"));
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

