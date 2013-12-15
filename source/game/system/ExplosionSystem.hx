package game.system; 

import ash.core.Node;
import flaxen.component.ActionQueue;
import flaxen.component.Alpha;
import flaxen.component.Emitter;
import flaxen.component.Image;
import flaxen.component.Layer;
import flaxen.component.Offset;
import flaxen.component.Origin;
import flaxen.component.Position;
import flaxen.component.Rotation;
import flaxen.component.Size;
import flaxen.component.Tween;
import flaxen.core.FlaxenSystem;
import flaxen.util.MathUtil;
import game.component.Damage;
import game.component.ExplodesOnDeath;
import game.component.Explosion;
import game.component.Health;
import com.haxepunk.HXP;

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
	private static var POWER_TO_RADIUS:Float = 1 / 2;
	private static var MIN_RADIUS:Float = 60;

	override public function update(time:Float)
	{
		// Show explosions and do damage
		for(node in ash.getNodeList(ExplosionNode))
		{
			var radius = node.explosion.power * POWER_TO_RADIUS;
			if(radius < MIN_RADIUS)
				radius = MIN_RADIUS;

			// Set off explosion effect
			createExplosion(radius, node.explosion, node.position);

			// Find all objects in radius			
			// Do damage to objects and possibly set on fire
			impactRadius(radius, node.explosion, node.position);

			// Remove explosion, although FX may still continue
			ash.removeEntity(node.entity);
		}
	}

	public function impactRadius(radius:Float, explosion:Explosion, position:Position)
	{
		for(node in ash.getNodeList(MortalNode))
		{
			var range = position.getDistanceTo(node.position);
			if(range <= radius)
				node.entity.add(new Damage(explosion.power));
		}
	}

	// TODO Change explosion size based on explosion power
	public function createExplosion(radius:Float, explosion:Explosion, position:Position)
	{
		var volume = Math.min(explosion.power / 400, 1) * 0.75 + 0.25; // scale volume to power, with min volume
 		addRadialExplosion(radius, explosion, position);
		addSmokeFX(radius, explosion, position);
		addExplosionFX(radius, explosion, position);
		flaxen.newSound("sound/explode" + MathUtil.rnd(1, 3) + ".wav", false, volume,
			(position.x - HXP.halfWidth) / HXP.halfWidth); // Set panning relative to explosion y position
	}

	public function addRadialExplosion(radius:Float, explosion:Explosion, position:Position)
	{
		var diameter = radius * 2;
		var size = new Size(diameter / 10, diameter / 10);
		var tween = new Tween(size, { width:diameter, height:diameter }, 0.3);
		tween.destroyEntity = true;
		flaxen.newEntity("radialExplosion")
			.add(new Image("art/explosion.png"))
			.add(new Layer(31))
			.add(position.clone())
			.add(size)
			.add(Offset.center())
			.add(Origin.center())
			.add(Rotation.random())
			.add(tween);
	}

	public function addExplosionFX(radius:Float, explosion:Explosion, position:Position)
	{
		var emitter = new Emitter("art/particle-smoke.png");
		emitter.destroyEntity = true;
		emitter.maxParticles = Math.floor(radius * radius / 30);
		emitter.lifespan = 0.3;
		emitter.lifespanRand = 0.05;
		emitter.distance = radius;
		emitter.stopAfterSeconds = 0.3;
		emitter.rotationRand = new Rotation(360);
		emitter.colorStart = 0xDDDD00;
		emitter.colorEnd = 0xFF2222;
		emitter.alphaStart = 0.5;

		flaxen.newEntity("emitter")
			.add(new Layer(30))
			.add(position.clone())
			.add(emitter);
	}

	public function addSmokeFX(radius:Float, explosion:Explosion, position:Position)
	{
		var emitter = new Emitter("art/particle-smoke.png");
		emitter.destroyEntity = true;
		emitter.maxParticles = Math.floor(radius * radius / 15);
		emitter.lifespan = 1.0;
		emitter.lifespanRand = 0.1;
		emitter.distance = radius * 1.5;
		emitter.rotationRand = new Rotation(360);
		emitter.stopAfterSeconds = 0.3;
		emitter.emitRadiusRand = radius / 10;
		emitter.alphaStart = 0.2;

		var e = flaxen.newEntity("emitter")
			.add(new Layer(29))
			.add(position.clone());

		// Delay emitter start
		e.add(new ActionQueue()
			.delay(0.25)
			.addComponent(e, emitter));
	}
}