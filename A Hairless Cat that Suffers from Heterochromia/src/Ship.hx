package /*src*/;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import openfl.Assets;

/**
 * ...
 * @author Vic
 */
class Ship extends Sprite
{

	public function new(x:Int, y:Int) 
	{
		super();
		var img = new Bitmap(Assets.getBitmapData("img/cat.png"));
		addChild(img);
		this.width = 50;
		this.height = 55.3;
		this.x = x;
		this.y = y;
	}
	
}