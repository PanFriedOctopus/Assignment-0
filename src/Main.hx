package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFormat;
import openfl.Assets;

/**
 * ...
 * @author Vic
 */

class Main extends Sprite 
{
	var inited:Bool;
	public var ship:Ship;
	var enemy:Enemy;
	var rightDown:Bool;
	var leftDown:Bool;
	public static var game:Main;
	public var bullets:List<Bullet>;
	public var badbullets:List<BadBullet>;
	public var enemies:List<Enemy>;
	var counter:Int;
	var onoff:Int;
	var menu:Sprite;
	var instructions:Sprite;
	var p:TextField;
	var m:TextField;
	
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
		game = this;
		bullets = new List<Bullet>();
		badbullets = new List<BadBullet>();
		enemies = new List<Enemy>();
		counter = 0;
		onoff = 0;
		
		menu = new Sprite();
		menu.graphics.beginFill(0xFFFFFF, .25);
		menu.graphics.drawRect(0, 0, 800, 480);
		var ts = new TextFormat(0);
		ts.font = "Courier New";
		ts.size = 40;
		ts.color = 0xFFFFFF;
		p = new TextField();
		p.text = 'Play Again';
		p.width = 500;
		p.setTextFormat(ts);
		menu.addChild(p);
		p.y = 50;
		p.x = 300;
		
		instructions = new Sprite();
		var tb = new TextFormat(0);
		tb.font = "Courier New";
		tb.size = 12;
		tb.color = 0xFFFFFF;
		m = new TextField();
		m.text = 'Move: Arrow Keys, Shoot: Space Bar, Menu: M';
		m.width = 500; 
		m.setTextFormat(tb);
		instructions.addChild(m);
		m.y = 2;
		m.x = 5;
		this.addChild(instructions);
		
		addEventListener(Event.ADDED_TO_STAGE, added);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, processKey);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, processUpKey);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, doStuff);
		p.addEventListener(MouseEvent.MOUSE_DOWN, playAgain_mouse);
		ship = new Ship (725, 200);
		this.addChild(ship);
		
		makeEnemies();
	}
	
	public function makeEnemies()
	{
		for (i in 0...6)
		{
			var enemy = new Enemy(100, Std.int(50 + 350 / 5 * i));
			this.addChild(enemy);
			enemies.add(enemy);
		}
	}
	function doStuff(e)
	{
		counter += 1;
		if (leftDown) ship.left();
		if (rightDown) ship.right();
		ship.act();
		for (bullets in bullets) bullets.act();
		for (badbullets in badbullets) badbullets.act();
		for (enemy in enemies) enemy.act();
		if (enemies.length<8 && counter % 60 == 0)
        {
            var enemy = new Enemy(100, Std.int(Math.random()*350+50));
            this.addChild(enemy);
            enemies.add(enemy);
        }
	}
	
	public function playAgain()
	{
		while (this.numChildren > 0) this.removeChildAt(0);
		this.addChild(ship);
		bullets = new List<Bullet>();
		enemies = new List<Enemy>();
		badbullets = new List<BadBullet>();
		ship.retry();
		makeEnemies();
		Lib.current.stage.focus = this.stage;
		onoff = 0;
		this.addChild(instructions);
		
	}
	
	public function playAgain_mouse(e:MouseEvent)
	{
		playAgain();
	}
	
	public function displayMenu()
	{
		//trace(onoff);
		if (onoff == 0)
		{
			ship.ttlyinvincible();
			this.addChild(menu);
			onoff = 1;
		}
		else if (onoff == 1)
		{
			ship.notinvincible();
			this.removeChild(menu);
			onoff = 0;
		}
		
	}
	function processKey(e:KeyboardEvent)
	{
		//trace(e.keyCode);
		if (e.keyCode == 38) leftDown = true;
		if (e.keyCode == 40) rightDown = true;
		if (e.keyCode == 32) ship.shoot();
		if (e.keyCode == 192) for (bullet in bullets) bullet.explode();
		if (e.keyCode == 82) playAgain();
		if (e.keyCode == 77) displayMenu();
	}
	function processUpKey(e:KeyboardEvent)
	{
		//trace(e.keyCode);
		if (e.keyCode == 38) leftDown = false;
		if (e.keyCode == 40) rightDown = false;
		//if (e.keyCode == 38) upDown = false;
		//if (e.keyCode == 40) downDown = false;
	}
	function move(e:MouseEvent)
	{
		var x = e.stageX;
		var y = e.stageY;
		this.x = x;
		this.y = y;
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
