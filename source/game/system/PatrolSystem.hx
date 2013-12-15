package game.system; 

import ash.core.Node;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.core.FlaxenSystem;
import game.component.Patrolling;

class PatrolNode extends Node<PatrolNode>
{
	public var patrol:Patrolling;
	public var position:Position;
	public var rotation:Rotation;
}

class PatrolSystem extends FlaxenSystem
{
	override public function update(time:Float)
	{
		for(node in ash.getNodeList(PatrolNode))
		{
		}
	}
}