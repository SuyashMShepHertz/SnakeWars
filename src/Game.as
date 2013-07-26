package
{
	import Screens.Menu;
	
	import starling.display.Sprite;
	
	public class Game extends Sprite
	{
		public function Game()
		{
			super();
			
			var menu:Sprite = new Menu();
			this.addChild(menu);
		}
	}
}