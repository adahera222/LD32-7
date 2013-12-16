package game.handler; 

import ash.core.Entity;
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
import flaxen.component.Animation;
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

class IntroHandler extends FlaxenHandler
{
	public var f:Flaxen;
	public var e1:Entity;
	public var e2:Entity;

	public function new(f:Flaxen)
	{
		super();
		this.f = f;
	}

	override public function start(_)
	{
		e1 = f.newEntity("title")
			.add(new Image("art/title.png"))
			.add(Position.zero())
			.add(new Layer(20));
		f.newMarker("p1");
	}

	override public function input(_)
	{
		if(InputService.clicked)
		{
			if(f.hasMarker("p1"))
			{
				var pos = Position.bottomLeft();
				e2 = f.newEntity("instructions")
					.add(new Image("art/instructions.png"))
					.add(pos);
				f.newTween(pos, { y:0 }, 0.65);
				f.removeMarker("p1");
				f.newMarker("p2");
			}

			else if(f.hasMarker("p2"))
			{
				f.removeMarker("p2");
				f.setMode(Play);
			}
		}
	}
}
