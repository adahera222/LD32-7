package game.component; 

import flaxen.component.Position;

// Patrolling is making a path to a target
class Patrolling
{
	public var target:Position;

	public function new(target:Position)
	{
		this.target = target;
	}
}