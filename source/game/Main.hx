package game; 

import flaxen.core.Flaxen;
import flaxen.core.FlaxenOptions;
import game.system.*;
import game.handler.*;
import flaxen.component.Application;

class Main extends Flaxen
{
	public static function main()
	{
		new Main();
	}

	override public function ready()
	{
		setHandler(new IntroHandler(this), Default);
		setHandler(new PlayHandler(this), Play);
		addSystems([GuardSystem, PatrolSystem, ExplosionSystem, DamageSystem, DeathSystem, 
			ScoreSystem, LevelCompleteSystem]);
	}
}
