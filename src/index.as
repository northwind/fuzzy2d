package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import controlers.GameFlow;
	
	[SWF(frameRate="24", bgcolor="0x000000" )]
	public class index extends Sprite
	{
		public var  world:MyWorld;
		
		public static var aaa:uint = 0;
		
		public function index()
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
				this.stage.align = StageAlign.TOP_LEFT;
			}
			
			world = new MyWorld();
			world.init( this );
			
			var flow:GameFlow = new GameFlow( world );
			flow.start();
		}

	}
}