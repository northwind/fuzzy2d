package
{
	import com.norris.fuzzy.core.display.impl.ImageLayer;
	import com.norris.fuzzy.core.resource.IResourceManager;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.*;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import models.*;
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import models.impl.PlayerModel;
	import models.impl.RecordModel;
	
	[SWF(frameRate="24", bgcolor="0x000000" )]
	public class TestSwfResource extends Sprite
	{
		public function TestSwfResource()
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

			var ct:Sprite = new Sprite();
			
			var r2:SWFResource  = new SWFResource( "navbar", "assets/navbar.swf", true );
			r2.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
				trace( "loaded" );
				
				var instance:MovieClip = r2.content as MovieClip;
//				ct.addChild( instance );
				
				var bar:MovieClip = new (r2.getSymbol( "NavBar" )) as MovieClip;
				bar.addEventListener( "auto", function( e:Event ) :void{
					trace( "auto event" );
				} );
				bar.graphics.beginFill( 0xCCCCCC );
				bar.graphics.drawRect( 0, 0, 1000, 30 );
				bar.graphics.endFill();
				ct.addChild( bar );

				var bg:MovieClip = r2.getMovieClip("DialogWrap");
				bg.y = 35;
				ct.addChild( bg );
				
			} );
			r2.load();		
			
			this.addChild( ct );
			
		}
		
		
		
	}
}