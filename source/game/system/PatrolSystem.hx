package game.system; 

import ash.core.Node;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.component.Tween;
import flaxen.core.FlaxenSystem;
import game.component.Patrolling;
import game.component.Guarding;

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
			// Tween exists, wait for motion to complete
			if(node.entity.has(Tween))
				continue;

			// Tween over and no more places to patrol, stop patrol
			if(node.patrol.path == null || node.patrol.index >= node.patrol.path.length)
				stopPatrol(node);

			// Tween over, patrol next place
			else continuePatrol(node);
		}
	}

	private function stopPatrol(node:PatrolNode)
	{
		node.entity.remove(Patrolling);
		node.entity.add(new Guarding(Math.random() * 4));
	}

	private function continuePatrol(node:PatrolNode)
	{
		// TODO if first patrol movement or last, use speed up/down easing
		// TODO if robot, animate walk
		// TODO get speed from robot/truck
		var speed = 120;
		var place = node.patrol.path[node.patrol.index];
		var nextPos = new Position(place.worldX, place.worldY);
		var dist = node.position.getDistanceTo(nextPos);
		if(dist <= 0)
		{
			stopPatrol(node);
			return;
		}

		var tween = new Tween(node.position, { x:nextPos.x, y:nextPos.y}, dist / speed);
		tween.destroyComponent = true;
		node.entity.add(tween);
		node.rotation.angle = node.position.getAngleTo(nextPos);
		node.patrol.index++;
	}
}