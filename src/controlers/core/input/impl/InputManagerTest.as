package controlers.core.input.impl
{
	import flash.display.Sprite;
	
	import flexunit.framework.Assert;
	
	public class InputManagerTest
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
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testSet_enable():void
		{
			var im:InputManager = new InputManager( new Sprite() );
			im.enableKeyboard = true;
			
			Assert.assertTrue( im.enableKeyboard == true );
		}
		
		[Test]
		public function testGet_enable():void
		{
			var im:InputManager = new InputManager( new Sprite() );
			im.enableKeyboard = true;
			
			Assert.assertTrue( im.enableKeyboard == true );
		}
		
		[Test]
		public function testReg():void
		{
			var im:InputManager = new InputManager( new Sprite() );
			im.on( InputKey.A , callback );
			im.on( InputKey.A , callback );
			
			Assert.assertTrue( im.count == 1 );
		}
		
		[Test]
		public function testUnreg():void
		{
			var im:InputManager = new InputManager( new Sprite() );
			im.on( InputKey.A, callback );
			im.on( InputKey.B, callback );
			im.on( InputKey.A, testReg );
			
			im.un( InputKey.A, callback );
			
			Assert.assertTrue(  im.count == 2  );
		}
		
		private function callback() :void
		{
		}
	}
}