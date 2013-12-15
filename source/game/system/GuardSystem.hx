package game.system; 

import ash.core.Node;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.core.FlaxenSystem;
import game.component.Guarding;
import game.component.Patrolling;

class GuardNode extends Node<GuardNode>
{
	public var position:Position;
	public var guarding:Guarding;
	public var rotation:Rotation;
}

class GuardSystem extends FlaxenSystem
{
	override public function update(time:Float)
	{
		for(node in ash.getNodeList(GuardNode))
		{
			node.guarding.timer -= time;
			if(node.guarding.timer < 0)
				patrol(node);
			else guard(node);
		}
	}

	public function patrol(node:GuardNode)
	{
		// TODO Add patrolling logic here
		node.guarding.timer = 100; // HACK

		// ash.removeEntity(node.entity);
	}

	public function guard(node:GuardNode)
	{
		if(Math.random() < 0.2)
			node.rotation.angle += 15;
	}
}