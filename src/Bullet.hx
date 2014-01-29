package ;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.Lib;
import openfl.Assets;
/**
 * ...
 * @author Vic
 */
class Bullet extends Sprite
{
	var goingLeft: Bool;
	var countdownToDestruction:Int;
	
	public function new(x:Int, y:Int, goingLeft:Bool) 
	{
		super();
		this.goingLeft = goingLeft;
		var img = new Bitmap(Assets.getBitmapData("img/clawmarks.png"));
		addChild(img);
		//this.width = 10;
		//this.height = 13;
		this.x = x;
		this.y = y;
		countdownToDestruction = -1;
	}
	
	public function explode()
	{
		countdownToDestruction = 60;
		this.removeChildAt(0);
		var img = new Bitmap(Assets.getBitmapData("img/poof.png"));
		addChild(img);
	}
	
	public function act()
	{
		if (countdownToDestruction < 0)
		{
			for (bullet in Main.game.bullets)
			{
				var d = Math.sqrt((this.x - bullet.x) * (this.x - bullet.x) + (this.y - bullet.y) * (this.y - bullet.y));
				if (this.goingLeft != bullet.goingLeft && d < 5 && bullet.countdownToDestruction < 0)
				{
					this.explode();
					bullet.explode();
					return;
				}
			}
			var ship = Main.game.ship;
			if (goingLeft)
			{
				this.x -= 3;
				for (enemy in Main.game.enemies)
				{
					var d = Math.sqrt((this.x - enemy.x) * (this.x - enemy.x) + (this.y - enemy.y) * (this.y - enemy.y));
					if (d < 30)
					{
						this.explode();
						enemy.kill();
						ship.numkilled += 1;
						
						//trace(ship.numkilled);
						
					}
				}
			}
			else 
			{
				this.y += 3;
				
				if (ship.isAlive)
				{
					var d = Math.sqrt((this.x - ship.x) * (this.x - ship.x) + (this.y - ship.y) * (this.y - ship.y));
					if (d < 30)
					{
						this.explode();
						ship.kill();
					}
				}
			}
		}
		else
		{
			this.alpha = countdownToDestruction / 60.0;
			countdownToDestruction -= 1;
		}
		if (countdownToDestruction == 0 || this.x < -this.width)
		{
			Main.game.bullets.remove(this);
			Main.game.removeChild(this);
		}
	}
	
}