package game.component; 

// Guarding is a pause before patrolling
class Guarding
{
	public var timer:Float;
	public var newlyAssigned:Bool = true;

	public function new(timer:Float)
	{
		this.timer = timer;
	}
}