package game.system; 

import ash.core.Node;
import com.haxepunk.masks.Grid;
import com.haxepunk.ai.GridPath;
import com.haxepunk.ai.PathNode;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.core.FlaxenSystem;
import flaxen.util.MathUtil;
import game.component.Guarding;
import game.component.Patrolling;
import game.component.Traveler;

class GuardNode extends Node<GuardNode>
{
	public var position:Position;
	public var guarding:Guarding;
	public var rotation:Rotation;
	public var traveler:Traveler;
}

class GuardSystem extends FlaxenSystem
{
	private var grid:Grid;
	private var aStar:GridPath;

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
		// read the static building map
		if(aStar == null)
		{
			grid = flaxen.demandEntity("fixedGrid").get(Grid);
			aStar = new GridPath(grid, { walkDiagonal:true });
		}
	
		// choose a point on the map not containing a static building, or just guess for now
		var x = MathUtil.rnd(0,29);
		var y = MathUtil.rnd(0,29);

		// A* to that position
		var sx = Std.int(node.position.x % 20);
		var sy = Std.int(node.position.y / 20);
		var path = aStar.search(sx, sy, x, y);

		// animate objects that have them
		node.entity.add(new Patrolling(path));
		node.entity.remove(Guarding);
	}

	public function guard(node:GuardNode)
	{
		if(node.guarding.newlyAssigned)
		{
			flaxen.installComponents(node.entity, node.traveler.type + "Healthy");
			node.guarding.newlyAssigned = false;			
		}

		if(node.traveler.type == "robot")
		{
			if(Math.random() < 0.2)
				node.rotation.angle += 15;
		}
	}
}