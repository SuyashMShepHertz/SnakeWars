package Screens
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class WaitScreen extends Sprite
	{
		private var txt:TextField;
		
		public function WaitScreen()
		{
			super();
			
			var bg:Image = new Image(Assets.getTextue("bg"));
			this.addChild(bg);
		
			txt = new TextField(800,480,"Please Wait!!! Connecting...");
			this.addChild(txt);
			
			AppWarp.connect(Connected);	
		}
		
		public function Connected(res:int):void
		{
			txt.text = "Joining a Game";
			AppWarp.join(Searching, Joined);
		}
		
		public function Searching():void
		{
			txt.text = "Searching for Opponent";
		}
		
		public function Joined():void
		{
			txt.text = "Opponent Found";
			var screen:Sprite = new MultiPlayer();
			this.parent.addChild(screen);
			this.removeFromParent(true);
		}
	}
}