package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.common.LoopType;
import flaxen.component.Image;
import flaxen.component.Layer;
import flaxen.component.Offset;
import flaxen.component.Origin;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.component.Tween;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;
import openfl.Assets;

class PlayHandler extends FlaxenHandler
{
	public static inline var XML_PATH:String = "data/game.xml";
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
		randomizeLevel(1000);
		// f.addDependent(group, e);
	}

	public function randomizeLevel(totalPoints:Int)
	{
		var e = f.newChildEntity("level", "levelObj");
		e.add(new Image("art/crates.png"))
			.add(Position.center())
			.add(Offset.center())
			.add(Origin.center())
			.add(new Rotation(Math.random() * 360))
			.add(new Layer(80));
	}
}