package game.component; 

class Level
{
	public var value:Int;  // current level number
	
	public var points:Int; // points for building level
	public var target:Int; // points needed to be gained by player
	public var score:Int;  // points grabbed so far
	public var count:Int;  // number of objects left to be blown up

	public function new()
	{
		this.value = 1;	
	}

	public function reset()
	{
		this.target = 0;
		this.points = 0;
		this.score = 0;
		this.count = 0;		
	}
}


