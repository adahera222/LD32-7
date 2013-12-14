package game; 

import flaxen.core.Flaxen;
import flaxen.core.FlaxenOptions;
import flaxen.system.MovementSystem;
import game.handler.PlayHandler;

class Main extends Flaxen
{
	public static function main()
	{
		new Main();
	}

	override public function ready()
	{
		setHandler(new PlayHandler(this));
		// addSystems([MovementSystem]);
	}
}
