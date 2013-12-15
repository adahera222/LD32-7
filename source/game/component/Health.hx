package game.component; 

// Current and max health, subject to damage
// Current between 0-max/2 is damaged
// Current < 0 is dead
class Health
{
	public var current:Int;
	public var max:Int;

	public function new(value:Int)
	{
		this.current = this.max = value;
	}
}