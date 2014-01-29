package ;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import openfl.Assets;
import flash.Lib;
/**
 * ...
 * @author Vic
 */
class Enemy extends Sprite
{
	var v:Float;
	var refx:Int;
	var counter:Int;
	var period:Float;
	
	public function new(x:Int, y:Int) 
	{
		super();
        var img = new Bitmap(Assets.getBitmapData("img/mouse.png"));
        var sprite = new Sprite();
        sprite.addChild(img);
        sprite.x = -img.width / 2;
        sprite.y = -img.height / 2;
        this.addChild(sprite);
        this.refx = y;
        this.x = x;
        this.y = y;
        this.counter = Std.int(Math.random() * 1000);
        this.period = Math.random() * 3 + 1;
		
	}
	
	public function kill()
	{
		Main.game.removeChild(this);
		Main.game.enemies.remove(this);
		var img = new Bitmap(Assets.getBitmapData("img/bigpoof.png"));
		addChild(img);
	}
	public function shoot()
	{
		var b:BadBullet = new BadBullet(Std.int(this.x), Std.int(this.y+this.height/2), false);
		Main.game.badbullets.add(b);
        Main.game.addChild(b);
	}
	public function act()
	{
		if (this.counter % 180 == 0) this.shoot();
        this.counter += 1;
        this.y =this.refx+ 30 * Math.sin(2 * Math.PI * this.counter / 60.0 / this.period);
    }
	
}