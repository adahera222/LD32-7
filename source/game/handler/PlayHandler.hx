package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.component.Image;
import flaxen.component.Origin;
import flaxen.component.Position;
import flaxen.component.Offset;
import flaxen.component.Layer;
import flaxen.component.Rotation;
import flaxen.component.Tween;
import flaxen.common.LoopType;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;

class PlayHandler extends FlaxenHandler
{
	public var f:Flaxen;

	public function new(f:Flaxen)
	{
		super();
		this.f = f;
	}

	override public function start(_)
	{
		var rot = new Rotation(0);
		var tween = new Tween(rot, { angle:360 }, 1.0);
		tween.loop = LoopType.Forward;

		var bomb = f.newSingleton("bomb")
			.add(new Image("art/bomb.png"))
			.add(Position.center())
			.add(Offset.center())
			.add(rot)
			.add(tween)
			.add(new Origin(16, 30))
			.add(new Layer(100));
	}

	override public function input(_)
	{
		var key = InputService.lastKey();
		InputService.clearLastKey();
	}
}
