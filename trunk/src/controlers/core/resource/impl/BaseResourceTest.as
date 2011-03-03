package controlers.core.resource.impl
{
	import controlers.core.resource.*;
	import controlers.core.resource.event.*;
	import controlers.core.resource.impl.*;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	public class BaseResourceTest
	{	
		public static var r:BaseResource = new BaseResource( "test base", "http://www.sinaimg.cn/cj/newjs/slg/images/bigmap/1-1.jpg", true ); 
		
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
			// run one time
//			BaseResourceTest.r.load();
			
			var r2:BinaryResource  = new BinaryResource( "test base", "http://eggs.sinaapp.com/main.php", true );
			
			r2.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
				
				var b:ByteArray = r2.content as ByteArray;
				trace( "length = " + b.length );
				trace( "readUTF = " + b.readUTF() );
				
			} );
			
			r2.load();
			
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test(async,timeout="40000")]
		public function testGet_bytesLoaded():void
		{
			Assert.assertEquals( 85980, BaseResourceTest.r.bytesTotal );
		}
		
		[Test(async,timeout="40000")]
		public function testGet_bytesTotal():void
		{
			Assert.assertEquals( 85980, BaseResourceTest.r.bytesTotal );
		}
		
		[Test]
		public function testClose():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.close();
		}
		
		[Test]
		public function testGet_content():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.close();
		}
		
		[Test]
		public function testDestroy():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.destroy();
		}
		
		[Test(async,timeout="40000")]
		public function testIsFailed():void
		{
			Assert.assertEquals( false, BaseResourceTest.r.isFailed() );
		}
		
		[Test(async,timeout="40000")]
		public function testIsFinish():void
		{
			Assert.assertEquals( true, BaseResourceTest.r.isFinish() );
		}
		
		[Test]
		public function testIsLoading():void
		{
			Assert.assertEquals( true, BaseResourceTest.r.isLoading() );
		}
		
		[Test(async,timeout="40000")]
		public function testGet_lastTime():void
		{
			Assert.assertTrue(  BaseResourceTest.r.lastTime > 0  );
		}
		
		[Test]
		public function testLoad():void
		{
			
		}
		
		[Test]
		public function testSet_name():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.name = "1";
			Assert.assertEquals( b.name, "1" );
		}
		
		[Test]
		public function testGet_name():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.name = "1";
			Assert.assertEquals( b.name, "1" );
		}
		
		[Test]
		public function testSet_policy():void
		{
		}
		
		[Test]
		public function testSet_request():void
		{
		}
		
		[Test]
		public function testReset():void
		{
		}
		
		[Test]
		public function testSet_url():void
		{
		}
		
		[Test]
		public function testGet_url():void
		{
		}
	}
}