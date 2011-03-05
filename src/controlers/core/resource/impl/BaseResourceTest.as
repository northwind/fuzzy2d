package controlers.core.resource.impl
{
	import controlers.core.resource.*;
	import controlers.core.resource.event.*;
	import controlers.core.resource.impl.*;
	
	import flash.display.*;
	import flash.utils.ByteArray;
	import flash.media.Sound;
	import flash.media.Video;
	
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
			
//			var r2:URLVariablesResource  = new URLVariablesResource( "test base", "http://slgengine.sinaapp.com/test/vars.txt", true );
//			
//			r2.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				trace( "answer = " + r2.getURLVars().answer );
//				trace( "toString = " + r2.getURLVars().toString() );
//				trace( "getString = " + r2.getString() ); 
//				
//			} );
//			
//			r2.load();
			
//			var r3:BinaryResource  = new BinaryResource( "test error binary", "http://eggs.sinaapp.com/maidddn.php", true );
//			
//			r3.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				var b:ByteArray = r3.getByteArray();
//				trace( "length = " + b.length );
//				trace( "readUTFBytes = " + r3.readUTF() ); 
//				
//			} );
//			
//			r3.load();
		
//			var r3:URLVariablesResource  = new URLVariablesResource( "test error binary", "http://eggs.sinaapp.com/maidddn.php", true );
//			
//			r3.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				trace( "answer = " + r3.getURLVars().answer );
//				trace( "toString = " + r3.getURLVars().toString() );
//				trace( "getString = " + r3.getString() ); 
//				
//			} );
//			
//			r3.load();
			
//			var r2:TextResource  = new TextResource( "test base", "http://slgengine.sinaapp.com/test/vars.txt", true );
//			
//			r2.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				trace( "getString = " + r2.getString() ); 
//				
//			} );
//			
//			r2.load();
//			
//			var r3:TextResource  = new TextResource( "test error binary", "http://eggs.sinaapp.com/maidddn.php", true );
//			
//			r3.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				trace( "getString = " + r3.getString() ); 
//				
//			} );
//			
//			r3.load();
			
//			var r2:JSONResource  = new JSONResource( "test base", "http://slgengine.sinaapp.com/test/json.txt", true );
//			
//			r2.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				trace( "name = " + r2.getJSON().name ); 
//				trace( "songs = " + r2.getJSON().songs ); 
//				trace( "songs.length = " + r2.getJSON().songs.length ); 
//				
//			} );
//			
//			r2.load();
//			
//			var r3:JSONResource  = new JSONResource( "test error binary", "http://eggs.sinaapp.com/maidddn.php", true );
//			
//			r3.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				trace( "name = " + r3.getJSON().name ); 
//				trace( "songs = " + r3.getJSON().songs ); 
//				
//			} );
//			
//			r3.load();
//			
//			var r4:JSONResource  = new JSONResource( "test error binary", "http://slgengine.sinaapp.com/test/json_wrong.txt", true );
//			
//			r4.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				trace( "name = " + r4.getJSON().name ); 
//				trace( "songs = " + r4.getJSON().songs ); 
//				
//			} );
//			
//			r4.load();
			
			
//			var r2:XMLResource  = new XMLResource( "test base", "http://slgengine.sinaapp.com/test/xml.xml", true );
//			
//			r2.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				var xml:XML = r2.getXML();
//				if ( xml != null )
//					trace( "2 children length = " + xml.children().length() );
//				
//			} );
//			
//			r2.load();
//			
//			var r3:XMLResource  = new XMLResource( "test error binary", "http://eggs.sinaapp.com/maidddn.xml", true );
//			
//			r3.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				var xml:XML = r3.getXML();
//				if ( xml != null )
//					trace( "3 children length = " + xml.children().length() );
//				
//			} );
//			
//			r3.load();
//			
//			var r4:XMLResource  = new XMLResource( "test error binary", "http://slgengine.sinaapp.com/test/xml_wrong.xml", true );
//			
//			r4.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				var xml:XML = r4.getXML();
//				if ( xml != null )
//					trace( "4 children length = " + xml.children().length() );
//				
//			} );
//			
//			r4.load();
				
//			var r2:ImageResource  = new ImageResource( "test base", "http://slgengine.sinaapp.com/test/image.gif", true );
//			
//			r2.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				var data:Bitmap = r2.getBitmap();
//				if ( data != null )
//					trace( "2 data height = " + data.height );
//				
//			} );
//			
//			r2.load();
//			
//			var r3:ImageResource  = new ImageResource( "test error binary", "http://eggs.sinaapp.com/maidddn.xml", true );
//			
//			r3.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				var data:Bitmap = r3.getBitmap();
//				if ( data != null )
//					trace( "3 data height = " + data.height );
//				
//			} );
//			
//			r3.load();
//			
//			var r4:ImageResource  = new ImageResource( "test error binary", "http://slgengine.sinaapp.com/test/xml_wrong.xml", true );
//			
//			r4.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
//				
//				var data:Bitmap = r4.getBitmap();
//				if ( data != null )
//					trace( "3 data height = " + data.height );
//				
//			} );
//			
//			r4.load();			
			
			var r2:SoundResource  = new SoundResource( "test base", "http://www.sinaimg.cn/cj/stockwin/images/battle.mp3", true );
			
			r2.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
				
				var data:Sound = r2.getSound();
				if ( data != null ){
					trace( "2 Sound length = " + data.length );
					data.play( );
				}
			} );
			
			r2.load();
			
			var r3:SoundResource  = new SoundResource( "test error binary", "http://eggs.sinaapp.com/maidddn.xml", true );
			
			r3.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
				
				var data:Sound = r3.getSound();
				if ( data != null )
					trace( "3 Sound length = " + data.length );
				
			} );
			
			r3.load();
			
			var r4:SoundResource  = new SoundResource( "test error binary", "http://slgengine.sinaapp.com/test/xml_wrong.xml", true );
			
			r4.addEventListener( ResourceEvent.COMPLETE, function( event:ResourceEvent ) : void {
				
				var data:Sound = r4.getSound();
				if ( data != null )
					trace( "3 Sound length = " + data.length );
				
			} );
			
			r4.load();	
			
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Ignore]
		[Test(async,timeout="40000")]
		public function testGet_bytesLoaded():void
		{
			Assert.assertEquals( 85980, BaseResourceTest.r.bytesTotal );
		}
		
		[Ignore]
		[Test(async,timeout="40000")]
		public function testGet_bytesTotal():void
		{
			Assert.assertEquals( 85980, BaseResourceTest.r.bytesTotal );
		}
		
		[Ignore]
		[Test]
		public function testClose():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.close();
		}
		
		[Ignore]
		[Test]
		public function testGet_content():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.close();
		}
		
		[Ignore]
		[Test]
		public function testDestroy():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.destroy();
		}
		
		[Ignore]
		[Test(async,timeout="40000")]
		public function testIsFailed():void
		{
			Assert.assertEquals( false, BaseResourceTest.r.isFailed() );
		}
		
		[Ignore]
		[Test(async,timeout="40000")]
		public function testIsFinish():void
		{
			Assert.assertEquals( true, BaseResourceTest.r.isFinish() );
		}
		
		[Ignore]
		[Test]
		public function testIsLoading():void
		{
			Assert.assertEquals( true, BaseResourceTest.r.isLoading() );
		}
		
		[Ignore]
		[Test(async,timeout="40000")]
		public function testGet_lastTime():void
		{
			Assert.assertTrue(  BaseResourceTest.r.lastTime > 0  );
		}
		
		[Ignore]
		[Test]
		public function testSet_name():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.name = "1";
			Assert.assertEquals( b.name, "1" );
		}
		
		[Ignore]
		[Test]
		public function testGet_name():void
		{
			var b:BaseResource = new BaseResource( "b", "123" );
			b.name = "1";
			Assert.assertEquals( b.name, "1" );
		}
		
		[Ignore]
		[Test]
		public function testSet_policy():void
		{
		}
		
		[Ignore]
		[Test]
		public function testSet_request():void
		{
		}
		
		[Ignore]
		[Test]
		public function testReset():void
		{
		}
		
		[Ignore]
		[Test]
		public function testSet_url():void
		{
		}
		
		[Ignore]
		[Test]
		public function testGet_url():void
		{
		}
	}
}