package game.system; 

import ash.core.Node;
import flaxen.component.Image;
import flaxen.component.Layer;
import flaxen.component.Position;
import flaxen.component.Scale;
import flaxen.component.Text;
import flaxen.core.FlaxenSystem;
import flaxen.core.Log;
import flaxen.util.StringUtil;
import game.component.Busy;
import game.component.Level;
import game.component.Controls;

class BusyNode extends Node<BusyNode>
{
	public var busy:Busy;
}

class LevelCompleteSystem extends FlaxenSystem
{
	override public function update(time:Float)
	{
		var level = flaxen.getComponent("level", Level);
		if(level == null)
			return; // Not playing game yet

		if(!level.dropped)
			return; // Bomb not dropped yet

		for(node in ash.getNodeList(BusyNode))
		{
			if(level.complete)
				Log.warn("Game over while things still happening");			
			return; // Game is busy with explosions and queued up earned points 
		}

		// Already ended level
		if(level.complete)
			return;

		// Level is over now!
		level.complete = true;
		flaxen.newControl(LevelComplete.instance);

		var mainText = flaxen.newChildSingleton("levelGroup", "endMessage")
			.add(new Image("art/giantFont.png"))
			.add(Position.center())
			// .add(Position.bottom().add(0, 400))
			// .add(Alpha.clear());
			// .add(new Scale(20, 20))
			.add(new Layer(18))
			.add(TextStyle.createBitmap(false, Center, Center, 0, -6, 0, "M", false, "ABCDEFGHIJKLMNOPQRSTUVWXYZ"));

		// Success, met target goal
		if(level.score >= level.target)
		{
			mainText.add(new Text("ACCEPTABLE"));
			level.success = true;			
		}
			
		else 
		{			
			mainText.add(new Text("TRY AGAIN"));
			level.success = false;
		}
	}
}
