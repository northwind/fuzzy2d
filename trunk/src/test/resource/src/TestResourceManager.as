package
{
	import flash.display.*;
	import flash.events.*;
	
	import resource.*;
	import resource.impl.ResourceManager;
	
	public class TestResourceManager extends Sprite
	{
		public function TestResourceManager()
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
			
			this.stage.addChild( this );
			
			var arr :Array = [ [ "face" , "http://www.sinaimg.cn/cj/newjs/slg/images/face/40-1.png" ],
				[ "face" , "http://www.sinaimg.cn/cj/newjs/slg/images/face/181-1.png" ],
				[ "face2" , "http://www.sinaimg.cn/cj/newjs/slg/images/face/40-1.png" ],
				
				[ "sword" , "http://www.sinaimg.cn/cj/newjs/slg/images/system/BTNSteelMelee.jpg" ],
				[ "follower" , "http://www.sinaimg.cn/cj/newjs/slg/images/item/94-1.png" ],
				[ "pearl" , "http://www.sinaimg.cn/cj/newjs/slg/images/item/87-1.png" ],
				[ "bean" , "http://www.sinaimg.cn/cj/newjs/slg/images/item/82-1.png" ],
				[ "mark" , "http://www.sinaimg.cn/cj/newjs/slg/images/magic/49-1.png" ],
				[ "move1", "http://www.sinaimg.cn/cj/newjs/slg/images/move/71-1.png" ],
				[ "bigmap", "http://www.sinaimg.cn/cj/newjs/slg/images/bigmap/1-1.jpg" ]
			];
			
			var resourceMgr:ResourceManager = new ResourceManager();
			
			for each( var item:Array in arr ){
				resourceMgr.addResource( resourceMgr.createResource( item[0], item[1], onComplete ) );
			}			
		}
		
		private function onComplete() : void
		{
			
		}
		
		private function addImage ( data:BitmapData ) : void
		{
			this.addChild( new Bitmap(  data ) );
		}
		
		
		
	}
}