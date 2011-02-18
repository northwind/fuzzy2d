package controlers.manager.impl
{
	import controlers.manager.events.ManagerEvent;
	
	import flexunit.framework.Assert;
	
	public class BaseManagerTest
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
		
		private function createItem( s:String ) :BaseItem  
		{
			var item:BaseItem = new BaseItem();
			return item;
		}
		
		[Test]
		public function testCount():void
		{
			var bm :BaseManager = new BaseManager();
			bm.reg( "1", createItem("123") );
			bm.reg( "2", createItem("123") );
			bm.reg( "3", createItem("123") );
			bm.reg( "1", createItem("123") );
			
			Assert.assertEquals( bm.count, 3 );
		}
		
		[Test]
		public function testDismiss():void
		{
			var bm :BaseManager = new BaseManager();
			bm.reg( "1", createItem("123") );
			bm.reg( "2", createItem("123") );
			
			bm.addEventListener( ManagerEvent.DISMISS, function ( event:ManagerEvent ) :void {
				trace( "DISMISS" );
			} );
			
			bm.dismiss();
		}
		
		[Test]
		public function testGet():void
		{
			var bm :BaseManager = new BaseManager();
			var item :BaseItem = createItem("123");
			bm.reg( "1", item );
			
			Assert.assertEquals( bm.get("1"), item );			
		}
		
		[Test]
		public function testHas():void
		{
			var bm :BaseManager = new BaseManager();
			var item :BaseItem = createItem("123");
			bm.reg( "1", item );
			
			Assert.assertTrue( bm.has("1") );	
		}
		
		[Test]
		public function testReg():void
		{
			var bm :BaseManager = new BaseManager();
			
			bm.addEventListener( ManagerEvent.REG, function ( event:ManagerEvent ) :void {
				trace( "onreg key = " + event.key + " item = " + event.item );
			} );
			
			bm.reg( "1", createItem("123") );
			bm.reg( "1", createItem("123") );
		}
		
		[Test]
		public function testUnreg():void
		{
			var bm :BaseManager = new BaseManager();
			
			bm.addEventListener( ManagerEvent.UNREG, function ( event:ManagerEvent ) :void {
				trace( "UNREG key = " + event.key + " item = " + event.item );
			} );
			
			bm.reg( "1", createItem("123") );
			bm.unreg( "2" );
			bm.unreg( "1" );
		}
	}
}