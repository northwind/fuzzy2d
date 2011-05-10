package  {
	
	import flash.display.Sprite;
	
	public class showUnit extends Sprite {
		
		
		public function showUnit() {
			// constructor code
			
		}
		
		public function showTip( type:int, na:String, level:int, maxHP:int, currentHP:int, offsetHP:int,
								 maxAtk:int, currentAtk:int, offsetAtk:int ):void
		{
			this.unitName.text = na;
			if ( type == 1 )		//敌军
				this.unitName.textColor = 0xff0000;		
			if ( type == 2 )		//友军
				this.unitName.textColor = 0x00ff00;
			if ( type == 3 )		//自己人
				this.unitName.textColor = 0xffff00;	
			
			this.unitLevel.text = level.toString();
			this.unitHP.text = currentHP.toString() + "/" + maxHP.toString();
			this.unitAtk.text = currentAtk.toString();
		}
	}
	
}
