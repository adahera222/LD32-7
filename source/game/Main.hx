package game; 

import flaxen.core.Flaxen;
import flaxen.core.FlaxenOptions;
import game.system.ExplosionSystem;
import game.system.DamageSystem;
import game.system.DeathSystem;
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
		addSystems([ExplosionSystem, DamageSystem, DeathSystem]);
	}
}
