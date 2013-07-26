package Screens
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class YouWin extends Sprite
	{
		public function YouWin()
		{
			super();
			
			var bg:Image = new Image(Assets.getTextue("bg"));
			this.addChild(bg);
			
			var logo:Image = new Image(Assets.getTextue("logo"));
			logo.x = 85;
			logo.y = 50;
			this.addChild(logo);
			
			var gameover:Image = new Image(Assets.getTextue("youwin"));
			gameover.x = 255;
			gameover.y = 200;
			this.addChild(gameover);
			
			var btn:Button = new Button(Assets.getTextue("menubtn"));
			btn.x = 336;
			btn.y = 350;
			this.addChild(btn);
			btn.addEventListener(Event.TRIGGERED, menuBtn_Click);
		}
		
		public function menuBtn_Click(event:Event):void
		{
			var screen:Sprite = new Menu;
			this.parent.addChild(screen);
			this.removeFromParent(true);
		}
	}
}