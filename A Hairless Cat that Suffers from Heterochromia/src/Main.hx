package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.display.BitmapData;
import flash.display.Bitmap;
import openfl.Assets;

/**
 * ...
 * @author Vic
 */

class Main extends Sprite 
{
	var inited:Bool;
	var ship:Ship;
	var leftDown:Bool;
	var rightDown:Bool;
	var upDown:Bool;
	var downDown:Bool;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, processKey);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, processUpKey);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, doStuff);
		ship = new Ship (50, 50);
		this.addChild(ship);
	}
	
	function doStuff(e)
	{
		if (leftDown) ship.x -= 3;
		if (rightDown) ship.x += 3;
		if (upDown) ship.y -= 3;
		if (downDown) ship.y += 3;
	}
	
	function processKey(e:KeyboardEvent)
	{
		//trace(e.keyCode);
		if (e.keyCode == 37) leftDown = true;
		if (e.keyCode == 39) rightDown = true;
		if (e.keyCode == 38) upDown = true;
		if (e.keyCode == 40) downDown = true;
	}
	function processUpKey(e:KeyboardEvent)
	{
		//trace(e.keyCode);
		if (e.keyCode == 37) leftDown = false;
		if (e.keyCode == 39) rightDown = false;
		if (e.keyCode == 38) upDown = false;
		if (e.keyCode == 40) downDown = false;
	}
	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
