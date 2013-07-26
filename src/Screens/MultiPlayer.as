package Screens
{
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class MultiPlayer extends Sprite
	{
		private const blockSize:int = 16;
		private var snake:Array;
		private var snakeRemote:Array;
		private var direction:int;
		private var directionRemote:int;
		private var speed:int = 100;
		private var food:Image;
		private var score:int = 0;
		private var txt:TextField;
		private var timer:Timer;
		private var count:int = 1;
		//private var remoteCommands:Array;
		
		public function MultiPlayer()
		{
			super();
			
			var bg:Image = new Image(Assets.getTextue("bg"));
			this.addChild(bg);
			
			food = new Image(Assets.getTextue("block"));
			food.x = -100;
			food.y = -100;
			this.addChild(food);
		
			snake = new Array();
			snakeRemote = new Array();
			//remoteCommands = new Array();
			
			snakeRemote.push(createBlock2(8,5));
			snakeRemote.push(createBlock2(7,5));
			snakeRemote.push(createBlock2(6,5));
			snakeRemote.push(createBlock2(5,5));
			
			snake.push(createBlock(8,5));
			snake.push(createBlock(7,5));
			snake.push(createBlock(6,5));
			snake.push(createBlock(5,5));
			
			direction = 2; // 1 - Left, 2 - Right, 3 - Top, 4 - Bottom
			directionRemote = 2;
			
			timer = new Timer(speed,0);
			timer.addEventListener(TimerEvent.TIMER, move);
			timer.start();
			
			putFood();
			
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_UP, keyDown);
			
			txt = new TextField(100,30,"Score : 0");
			this.addChild(txt);
			
			AppWarp.begin(OnMsg, onLeave,direction, snake[0].x,snake[0].y);
		}
		
		private function createBlock(x:int, y:int):Image
		{
			var img:Image = new Image(Assets.getTextue("block"));
			img.x = x*blockSize;
			img.y = y*blockSize;
			
			this.addChild(img);
			
			return img;
		}
		
		private function createBlock2(x:int, y:int):Image
		{
			var img:Image = new Image(Assets.getTextue("block2"));
			img.x = x*blockSize;
			img.y = y*blockSize;
			
			this.addChild(img);
			
			return img;
		}
		
		private function move(event:TimerEvent):void
		{
			var px:int = snake[0].x;
			var py:int = snake[0].y;
			
			if(direction == 1)
			{
				snake[0].x -= blockSize;
			}
			else if(direction == 2)
			{
				snake[0].x += blockSize;
			}
			else if(direction == 3)
			{
				snake[0].y -= blockSize;
			}
			else if(direction == 4)
			{
				snake[0].y += blockSize;
			}
			
			for(var i:int = 1; i<snake.length; ++i)
			{
				var tx:int = snake[i].x;
				var ty:int = snake[i].y;
				
				snake[i].x = px;
				snake[i].y = py;
				
				px = tx;
				py = ty;
			}
			
			isEatenFood();
			checkDeath();
			
			count++;
			if(count > 20)
			{
				score += 10;
				count = 0;
				if(timer.delay > 10)
					timer.delay -= 1
			}		
			
			txt.text = "Score : " + score;
			
			//moveRemote(event);
			processRemote();
		}
		
		private function processRemote():void
		{
			moveRemote();
		}
		
		private function moveRemote():void
		{
			var px:int = snakeRemote[0].x;
			var py:int = snakeRemote[0].y;
			
			if(directionRemote == 1)
			{
				snakeRemote[0].x -= blockSize;
			}
			else if(directionRemote == 2)
			{
				snakeRemote[0].x += blockSize;
			}
			else if(directionRemote == 3)
			{
				snakeRemote[0].y -= blockSize;
			}
			else if(directionRemote == 4)
			{
				snakeRemote[0].y += blockSize;
			}
			
			for(var i:int = 1; i<snakeRemote.length; ++i)
			{
				var tx:int = snakeRemote[i].x;
				var ty:int = snakeRemote[i].y;
				
				snakeRemote[i].x = px;
				snakeRemote[i].y = py;
				
				px = tx;
				py = ty;
			}
		}
		
		private function keyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == 37)
			{
				if(direction == 3 || direction == 4)
					direction = 1;
			}
			else if(event.keyCode == 38)
			{
				if(direction == 1 || direction == 2)
					direction = 3;
			}
			else if(event.keyCode == 39)
			{
				if(direction == 3 || direction == 4)
					direction = 2;
			}
			else if(event.keyCode == 40)
			{
				if(direction == 1 || direction == 2)
					direction = 4;
			}
			
			AppWarp.move(direction, snake[0].x,snake[0].y);
		}
		
		private function putFood():void
		{
			var x:int = Math.random()*50;
			var y:int = Math.random()*30;
			
			food.x = x*blockSize;
			food.y = y*blockSize;
		}
		
		public function isEatenFood():void
		{
			if(food.getBounds(this.parent).intersects(snake[0].getBounds(this.parent)))
			{
				var img:Image = new Image(Assets.getTextue("block"));
				img.x = snake[snake.length-1].x;
				img.y = snake[snake.length-1].y;
				this.addChild(img);
				
				snake.push(img);
				
				score += 1000;
				txt.text = "Score : " + score;
				putFood();
				
				AppWarp.eat(direction, snake[0].x,snake[0].y);
			}
		}
		
		public function checkDeath():void
		{
			var death:Boolean = false;
			for(var i:int = 1; i<snake.length; ++i)
			{
				
				if(snake[0].getBounds(this.parent).intersects(snake[i].getBounds(this.parent)))
				{
					death = true;
				}
			}
			
			if(snake[0].x < 0 || snake[0].y < 0)
			{
				death = true;
			}
			
			if(snake[0].x > 50*blockSize || snake[0].y > 30*blockSize)
			{
				death = true;
			}
				
			if(death == true)
			{
				timer.stop();
				AppWarp.leave();
				var screen:Sprite = new GameOver();
				this.parent.addChild(screen);
				this.removeFromParent(true);
			}
		}
		
		private function OnMsg(obj:Object):void
		{
			directionRemote = obj.dir;
			
			if(obj.type == 2)
			{
				var img:Image = new Image(Assets.getTextue("block2"));
				img.x = snakeRemote[snakeRemote.length-1].x;
				img.y = snakeRemote[snakeRemote.length-1].y;
				this.addChild(img);
				
				snakeRemote.push(img);
			}
		}
		
		private function onLeave():void
		{
			try
			{
				timer.stop();
				AppWarp.leave();
				var screen:Sprite = new YouWin();
				this.parent.addChild(screen);
				this.removeFromParent(true);
			}
			catch(error:Error)
			{
				trace(error.message);
			}
		}
	}
}