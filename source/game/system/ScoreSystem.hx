package game.system; 

import ash.core.Node;
import com.haxepunk.masks.Grid;
import flaxen.common.Easing;
import flaxen.common.LoopType;
import flaxen.component.Image;
import flaxen.component.Layer;
import flaxen.component.Position;
import flaxen.component.Scale;
import flaxen.component.Text;
import flaxen.component.Tween;
import flaxen.core.FlaxenSystem;
import flaxen.util.StringUtil;
import game.component.EarnedPoints;
import game.component.Level;

class EarnedPointsNode extends Node<EarnedPointsNode>
{
	public var points:EarnedPoints;
}

class ScoreSystem extends FlaxenSystem
{
	override public function update(time:Float)
	{
		for(node in ash.getNodeList(EarnedPointsNode))
		{
			// Decrement level object counter 				
			var level = flaxen.demandComponent("level", Level);
			level.score += node.points.points;

			// Remove this entity
			ash.removeEntity(node.entity);

			// Add the score thing
			var scoreEnt = flaxen.resolveEntity("score");
			if(scoreEnt.has(Text))
				scoreEnt.get(Text).message = StringUtil.formatCommas(level.score);
			else
			{
				flaxen.addDependentByName("levelGroup", scoreEnt.name);
				scoreEnt.add(new Image("art/redNumberFont.png"))
					.add(new Position(5, 5))
					.add(new Layer(20))
					.add(Scale.full())
					.add(new Text(StringUtil.formatCommas(level.score)))
					.add(TextStyle.createBitmap(false, Left, Top, 0, -2, 0, "2", false, "1234567890,"));
			}

			if(!scoreEnt.has(Tween))
			{
				var tween = new Tween(scoreEnt.get(Scale), { x:1.1, y:1.1 }, 0.1, Easing.easeInOutQuad);
				tween.loop = LoopType.Both;
				tween.stopAfterLoops = 2;
				tween.destroyComponent = true;
				scoreEnt.add(tween);
			}
		}
	}
}
