package controlers.core.resource.impl
{
	import flexunit.framework.Assert;
	import controlers.core.resource.*;
	import controlers.core.resource.event.*;
	
	public class ResourceManagerTest1
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			var arr :Array = [ [ "face" , "http://www.sinaimg.cn/cj/newjs/slg/images/face/40-1.png" ],
				[ "face" , "http://www.sinaimg.cn/cj/newjs/slg/images/face/181-1.png" ],
				[ "face2" , "http://www.sinaimg.cn/cj/newjs/slg/images/face/40-1.png" ],
				
				[ "sword" , "http://www.sinaimg.cn/cj/newjs/slg/images/system/BTNSteelMelee.jpg" ],
				[ "follower" , "http://www.sinaimg.cn/cj/newjs/slg/images/item/94-1.png" ],
				[ "pearl" , "http://www.sinaimg.cn/cj/newjs/slg/images/item/87-1.png" ],
				[ "bean" , "http://www.sinaimg.cn/cj/newjs/slg/images/item/82-1.png" ],
				[ "mark" , "http://www.sinaimg.cn/cj/newjs/slg/images/magic/49-1.png" ],
				[ "move1", "http://www.sinaimg.cn/cj/newjs/slg/images/move/71-1.png" ],
				[ "bigmap", "http://www.sinaimg.cn/cj/newjs/slg/images/bigmap/1-1.jpg" ],
				[ "wrongpng", "http://www.sinaimg.cn/cddddg.jpg" ]
			];
			
			var resourceMgr:IResourceManager = new ResourceManager();
			resourceMgr.local = "cn";
			
			resourceMgr.add( "http://www.sinaimg.cn/cj/stockwin/images/stockC_nav.png" );
			
			var names:Array = [];
			
			for each( var item:Array in arr ){
				resourceMgr.add( item[0] as String, item[1], true, BaseResource );
				
				names.push( item[0] );
			}
			
			resourceMgr.load( "notexist", function():void {}, function():void {} );
			
			resourceMgr.remove( "face2" );
			
			resourceMgr.load( "bigmap", function( event :ResourceEvent ):void {
				trace(  "process : bytesLoaded = " + event.bytesLoaded  );
				trace(  "process : bytesTotal = " + event.bytesTotal  );
				trace(  "process : speed = " + event.speed  );
				trace(  "process : percent = " + event.percent  );
				trace(  "process : ok = " + event.ok  );
				trace(  "----------------------------------------------------"  );
				
				resourceMgr.stop( event.resource.name );
				
			}, function ( event :ResourceEvent ):void {
				trace(  "complete : bytesLoaded = " + event.bytesLoaded  );
				trace(  "complete : bytesTotal = " + event.bytesTotal  );
				trace(  "complete : speed = " + event.speed  );
				trace(  "complete : percent = " + event.percent  );
				trace(  "complete : ok = " + event.ok  );
				trace(  "complete : success count = " + event.success.length  );
				trace(  "complete : failed count = " + event.failed.length  );
				trace(  "----------------------------------------------------"  );
			} );	
			
			resourceMgr.load( "notexist" );
			
			resourceMgr.load( names,function( event :ResourceEvent ):void {
				trace(  "process : bytesLoaded = " + event.bytesLoaded  );
				trace(  "process : bytesTotal = " + event.bytesTotal  );
				trace(  "process : lasttime = " + event.lastTime  );
				trace(  "process : speed = " + event.speed  );
				trace(  "process : percent = " + event.percent  );
				trace(  "process : ok = " + event.ok  );
				trace(  "process : success count = " + event.success.length  );
				trace(  "process : failed count = " + event.failed.length  );
				trace(  "----------------------------------------------------"  );
			}, function ( event :ResourceEvent ):void {
				trace(  "complete : bytesLoaded = " + event.bytesLoaded  );
				trace(  "complete : bytesTotal = " + event.bytesTotal  );
				trace(  "complete : lasttime = " + event.lastTime  );
				trace(  "complete : speed = " + event.speed  );
				trace(  "complete : percent = " + event.percent  );
				trace(  "complete : ok = " + event.ok  );
				trace(  "complete : success count = " + event.success.length  );
				trace(  "complete : failed count = " + event.failed.length  );
				trace(  "----------------------------------------------------"  );
			} );	
			
//			resourceMgr.stop( ["bean", "mark", "move1", "bigmap", "wrongpng" ] );
			
			names.push( "http://www.sinaimg.cn/cj/stockwin/images/stockC_nav.png" );
			
			resourceMgr.load( names,function( event :ResourceEvent ):void {
				trace(  "process2 : percent = " + event.percent  );
				trace(  "----------------------------------------------------"  );
			}, function ( event :ResourceEvent ):void {
				trace(  "222222222222222222222222222222"  );
				trace(  "complete2 : bytesLoaded = " + event.bytesLoaded  );
				trace(  "complete2 : bytesTotal = " + event.bytesTotal  );
				trace(  "complete2 : lasttime = " + event.lastTime  );
				trace(  "complete2 : speed = " + event.speed  );
				trace(  "complete2 : percent = " + event.percent  );
				trace(  "complete2 : ok = " + event.ok  );
				trace(  "complete2 : success count = " + event.success.length  );
				trace(  "complete2 : failed count = " + event.failed.length  );
				trace(  "----------------------------------------------------"  );
			} );
			
			resourceMgr.reload( names,function( event :ResourceEvent ):void {
				trace(  "process3 : percent = " + event.percent  );
			}, function ( event :ResourceEvent ):void {
				trace(  "33333333333333333333333333333333333333"  );
				trace(  "complete3 : bytesLoaded = " + event.bytesLoaded  );
				trace(  "complete3 : bytesTotal = " + event.bytesTotal  );
				trace(  "complete3 : lasttime = " + event.lastTime  );
				trace(  "complete3 : speed = " + event.speed  );
				trace(  "complete3 : percent = " + event.percent  );
				trace(  "complete3 : ok = " + event.ok  );
				trace(  "complete3 : success count = " + event.success.length  );
				trace(  "complete3 : failed count = " + event.failed.length  );
				trace(  "----------------------------------------------------"  );
			} );
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testResourceManager():void
		{
		}
	}
}