package controlers.core.manager.impl
{
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
		
		[Test]
		public function testGet_count():void
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
			
			bm.dismiss();
		}
		
		[Test]
		public function testGet():void
		{
			var bm :BaseManager = new BaseManager();
			var item :BaseItem = createItem("123");
			bm.reg( "1", item );
			
			Assert.assertEquals( bm.find("1"), item );			
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
			
			bm.reg( "1", createItem("123") );
			bm.reg( "1", createItem("123") );
		}
		
		[Test]
		public function testUnreg():void
		{
			var bm :BaseManager = new BaseManager();
			
			bm.reg( "1", createItem("123") );
			bm.unreg( "2" );
			bm.unreg( "1" );
		}
		
		private function createItem( s:String ) :BaseItem  
		{
			var item:BaseItem = new BaseItem();
			return item;
		}
	}
}