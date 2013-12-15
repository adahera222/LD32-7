package game.system; 

import ash.core.Node;
import com.haxepunk.masks.Grid;
import flaxen.component.Layer;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.component.Image;
import flaxen.core.FlaxenSystem;
import flaxen.util.MathUtil;
import game.component.Damage;
import game.component.Dying;
import game.component.ExplodesOnDeath;
import game.component.Explosion;
import game.component.Health;
import game.component.Immobile;
import game.component.Level;
import game.component.AwardsPoints;

class DeathNode extends Node<DeathNode>
{
	public var image:Image;
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
				// Handle death-moment effects
				if(node.entity.has(ExplodesOnDeath))
				{
					var eod = node.entity.get(ExplodesOnDeath);
					flaxen.newEntity("explosion")
						.add(node.position)
						.add(new Explosion(eod.power));
				}

				// Decrement level object counter 				
				var level = flaxen.demandComponent("level", Level);
				level.count--;
				// trace("Objects left:" + level.count);

				if(node.entity.has(AwardsPoints))
					level.score += node.entity.get(AwardsPoints).points;
				trace("SCORE:" + level.score);

				// Deregister entity from fixed grid				
				if(node.entity.has(Immobile))
				{
					var type = node.entity.get(Immobile).type;
					var fixedGrid = flaxen.demandEntity("fixedGrid").get(Grid);
					fixedGrid.setRect(node.position.x - node.image.width / 2, 
						node.position.y - node.image.height / 2, 
						node.image.width, node.image.height, false);
				}

				// Actually remove the entity
				ash.removeEntity(node.entity);
			}
		}
	}
}