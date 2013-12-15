package game.component; 

import com.haxepunk.ai.PathNode;

// Patrolling is making a path to a target
class Patrolling
{
	public var path:Array<PathNode>;
	public var index:Int = 0;

	public function new(path:Array<PathNode> = null)
	{
		this.path = path;
	}
}