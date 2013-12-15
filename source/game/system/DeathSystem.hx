package game.system; 

import ash.core.Node;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.component.Layer;
import flaxen.core.FlaxenSystem;
import flaxen.util.MathUtil;
import game.component.Explosion;
import game.component.Health;
import game.component.Damage;
import game.component.ExplodesOnDeath;
import game.component.Dying;

class DeathNode extends Node<DeathNode>
{
	public var position:Position;
	public var dying:Dying;
}

// Applies damage
class DeathSystem extends FlaxenSystem
{
	override public function update(time:Float)
	{
		for(node in ash.getNodeList(DeathNode))
		{
			node.dying.timer -= time;
			if(node.dying.timer <= 0)
			{
				if(node.entity.has(ExplodesOnDeath))
				{
					var eod = node.entity.get(ExplodesOnDeath);
					flaxen.newEntity("explosion")
						.add(node.position)
						.add(new Explosion(eod.power));
				}

				ash.removeEntity(node.entity);
			}
		}
	}
}