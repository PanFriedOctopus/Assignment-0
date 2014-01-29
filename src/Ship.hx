package /*src*/;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.Lib;
import openfl.Assets;

/**
 * ...
 * @author Vic
 */
class Ship extends Sprite
{
	var v:Float;
	public var isAlive:Bool;
	public var invincible:Bool;
	var health:Int;
	public var numkilled:Int;
	var MAX_HEALTH = 5;
	var health_bar:Sprite;
	
	public function new(x:Int, y:Int) 
	{
		super();
		numkilled = 0;
		health = MAX_HEALTH;
		isAlive = true;
		var sprite = new Sprite();
		var img = new Bitmap(Assets.getBitmapData("img/cat.png"));
		sprite.addChild(img);
		sprite.x = -img.width / 2;
        sprite.y = -img.height / 2;
        this.addChild(sprite);
		
		health_bar = new Sprite();
		health_bar.graphics.beginFill(0x25B11A, .5);
		health_bar.graphics.drawRect(3, 0, img.width, 5);
		sprite.addChild(health_bar);
		health_bar.y = -8;
		
		this.x = x;
		this.y = y;
		this.v = 0;
	}
	public function left()
	{
		if (invincible == false)
		{
			this.v -= 1;
		}
	}
	public function right()
	{
		if (invincible == false)
		{
			this.v += 1;
		}
	}
	
	public function act()
	{
		health_bar.width = 44 * health / MAX_HEALTH;
		if (this.y < 0 && this.v < 0) this.v = 0;
		if (this.y > 483 - this.height && this.v > 0) this.v = 0;
		this.v *= .9;
		this.y += this.v;
	}
	
	public function shoot()
	{
		if (isAlive && invincible == false)
		{
			var b:Bullet = new Bullet(Std.int(this.x + this.width / 2)-10, Std.int(this.y)+15, true);
			Main.game.bullets.add(b);
			Main.game.addChild(b);
		}
	}
	
	public function ttlyinvincible()
	{
		//trace(invincible);
		invincible = true;
	}
	
	public function notinvincible()
	{
		invincible = false;
	}
	
	public function kill()
	{
		if (invincible == false)
		{
			this.health -= 1;
			if (health <= 0)
			{
				Main.game.displayMenu();
				Main.game.removeChild(this);
				isAlive = false;
			}
		}
	}
	public function retry()
	{
		isAlive = true;
		invincible = false;
		numkilled = 0;
		health = MAX_HEALTH;
	}
}