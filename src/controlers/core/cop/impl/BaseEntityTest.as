package controlers.core.cop.impl
{
	import controlers.core.cop.IEntity;
	import controlers.core.cop.IComponent;
	import flexunit.framework.Assert;
	
	public class BaseEntityTest
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
		public function testAddComponent():void
		{
			var c:BaseComponent = new BaseComponent();
			var entity:Entity = new Entity();
			entity.addComponent( c );
			Assert.assertTrue( true );
		}
		
		[Test]
		public function testDestroy():void
		{
			var c:BaseComponent = new BaseComponent();
			var entity:Entity = new Entity();
			entity.addComponent( c );
			entity.destroy();
			Assert.assertTrue( true );
			
		}
		
		[Test]
		public function testSetup():void
		{
			var c:BaseComponent = new BaseComponent();
			var entity:Entity = new Entity();
			entity.addComponent( c );
			entity.setup();
			
			Assert.assertTrue( true );
		}
	}
}