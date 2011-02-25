package
{
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import impl.BaseAI;
	import impl.BaseAttack;
	import impl.BaseCommand;
	import impl.BaseFigure;
	import impl.BaseMove;
	import impl.BaseRole;
	
	public class TestCOP extends Sprite
	{
		public function TestCOP()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			if ( this.stage )
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			
			var a:BaseRole = new BaseRole( new BaseCommand() );
//			a.addComponent( new BaseFigure() );
//			a.addComponent( new BaseAttack() );
//			a.addComponent( new BaseMove() );
			a.addComponent( new BaseAI() );
			
			a.action( "move", [10,20], function ():void{
				trace( "move callback" );
			} );
			
		}
		
	}
}