package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	
	public class XXXXX extends Sprite {
		
		
		public function XXXXX() {
			// constructor code
			
			showUnit( 1, "test", 13, 100, 80, 10, 30, 20, 5 );
		}
		
		public function showUnit( type:int, na:String, level:int, maxHP:int, currentHP:int, offsetHP:int,
								 maxAtk:int, currentAtk:int, offsetAtk:int ):void
		{
			this.unitName.text = na;
			if ( type == 1 )
				this.unitName.textColor = 0xff0000;
			
			this.unitLevel.text = level.toString();
			this.unitHP.text = currentHP.toString() + "/" + maxHP.toString();
			this.unitAtk.text = currentAtk.toString();
		}
		
	}
	
}
