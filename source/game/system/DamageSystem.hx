package game.system; 

import ash.core.Node;
import flaxen.component.Position;
import flaxen.core.FlaxenSystem;
import flaxen.util.MathUtil;
import game.component.Damage;
import game.component.Dying;
import game.component.Health;
import game.component.Busy;

class DamageNode extends Node<DamageNode>
{
	public var damage:Damage;
	public var health:Health;
}

// Applies damage
class DamageSystem extends FlaxenSystem
{
	private static inline var DEATH_TIMER_MIN:Float = 0.5;
	private static inline var DEATH_TIMER_MAX:Float = 2;

	override public function update(time:Float)
	{
		for(node in ash.getNodeList(DamageNode))
		{
			node.health.current -= node.damage.value;
			node.entity.remove(Damage);

			if(node.health.current < 0)
			{
				node.entity.add(new Dying(MathUtil.rnd(DEATH_TIMER_MIN, DEATH_TIMER_MAX)));
				node.entity.add(Busy.instance);
			}

			else if(node.health.current <= node.health.max / 2)
				showDamage(node);
		}
	}

	public function showDamage(node:DamageNode)
	{
		// TODO Show cracks/rips/wear on objects
		// Add object-appropriate sound effect
		return;
	}
}