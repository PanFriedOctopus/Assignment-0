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
class BadBullet extends Sprite
{
	var goingLeft: Bool;
	var countdownToDestruction:Int;
	
	public function new(x:Int, y:Int, goingLeft:Bool) 
	{
		super();
		this.goingLeft = goingLeft;
		var img = new Bitmap(Assets.getBitmapData("img/cheese.png"));
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
			for (badbullet in Main.game.badbullets)
			{
				var d = Math.sqrt((this.x - badbullet.x) * (this.x - badbullet.x) + (this.y - badbullet.y) * (this.y - badbullet.y));
				if (this.goingLeft != badbullet.goingLeft && d < 5 && badbullet.countdownToDestruction < 0)
				{
					this.explode();
					badbullet.explode();
					return;
				}
			}
			if (goingLeft)
			{
				this.y += 3;
				for (enemy in Main.game.enemies)
				{
					var d = Math.sqrt((this.x - enemy.x) * (this.x - enemy.x) + (this.y - enemy.y) * (this.y - enemy.y));
					if (d < 30)
					{
						this.explode();
						enemy.kill();
					}
				}
			}
			else 
			{
				this.x += 3;
				var ship = Main.game.ship;
				if (ship.isAlive)
				{
					var d = Math.sqrt((this.x - ship.x) * (this.x - ship.x) + (this.y - ship.y) * (this.y - ship.y));
					if (d < 30)
					{
						if (ship.invincible == false)
						{
							this.explode();
						}
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
			Main.game.badbullets.remove(this);
			Main.game.removeChild(this);
		}
	}
	
}