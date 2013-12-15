package game.system; 

import ash.core.Node;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.component.Layer;
import flaxen.core.FlaxenSystem;
import flaxen.component.Emitter;
import flaxen.util.MathUtil;
import game.component.Explosion;
import game.component.Health;
import game.component.Damage;
import game.component.ExplodesOnDeath;

class ExplosionNode extends Node<ExplosionNode>
{
	public var position:Position;
	public var explosion:Explosion;
}

class MortalNode extends Node<MortalNode>
{
	public var position:Position;
	public var health:Health;
}

class ExplosionSystem extends FlaxenSystem
{
	private static var POWER_TO_RADIUS:Float = 120 / 400;
	private static var MIN_RADIUS:Float = 60;

	override public function update(time:Float)
	{
		// Check to see if exploding things are exploded now
		// TODO

		// Show explosions and do damage
		for(node in ash.getNodeList(ExplosionNode))
		{
			// Set off explosion effect
			createExplosion(node);

			// Find all objects in radius			
			// Do damage to objects and possibly set on fire
			impactRadius(node);

			// Remove explosion, although FX may still continue
			ash.removeEntity(node.entity);
		}
	}

	public function impactRadius(explodeNode:ExplosionNode)
	{
		var power = explodeNode.explosion.power;
		var radius = power * POWER_TO_RADIUS;
		for(node in ash.getNodeList(MortalNode))
		{
			var range = explodeNode.position.getDistanceTo(node.position);
			if(range <= radius)
				node.entity.add(new Damage(power));
		}
	}

	// TODO Change explosion size based on explosion power
	public function createExplosion(node:ExplosionNode)
	{
		addSmoke(node.position);
		addExplosion(node.position);
	}

	public function addExplosion(pos:Position)
	{
		var emitter = new Emitter("art/particle-smoke.png");
		emitter.destroyEntity = true;
		emitter.maxParticles = 500;
		emitter.lifespan = 0.3;
		emitter.distance = 120;
		emitter.stopAfterSeconds = 0.3;
		emitter.rotationRand = new Rotation(360);
		emitter.colorStart = 0xDDDD00;
		emitter.colorEnd = 0xFF2222;

		flaxen.newEntity("emitter")
			.add(new Layer(30))
			.add(pos)
			.add(emitter);

		flaxen.newSound("sound/explode" + MathUtil.rnd(1, 3) + ".wav");
	}

	public function addSmoke(pos:Position)
	{
		var emitter = new Emitter("art/particle-smoke.png");
		emitter.destroyEntity = true;
		emitter.maxParticles = 200;
		emitter.lifespan = 1.6;
		emitter.lifespanRand = 0.3;
		emitter.distance = 40;
		emitter.rotation = new Rotation(315);
		emitter.rotationRand = new Rotation(150);
		emitter.stopAfterSeconds = 1.0;
		emitter.emitRadiusRand = 60;

		flaxen.newEntity("emitter")
			.add(new Layer(30))
			.add(pos)
			.add(emitter);
	}
}