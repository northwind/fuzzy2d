package com.norris.fuzzy.core.resource.impl
{
	import flexunit.framework.Assert;
	import com.norris.fuzzy.core.resource.*;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	
	public class ResourceManagerTest
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
		public function testAdd():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "http://www.sinaimg.cn/cj/newjs/slg/images/bigmap/1-1.jpg", true );
			mgr.add( "aaa", "dddd" );
			mgr.add( "bbb", "bbb" );
			
			Assert.assertEquals( mgr.count, 2 );
		}
		
		[Test]
		public function testDestroyAll():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "http://www.sinaimg.cn/cj/newjs/slg/images/bigmap/1-1.jpg", true );
			mgr.add( "aaa", "dddd" );
			mgr.add( "bbb", "bbb" )
				
			mgr.destroyAll();	
		}
		
		[Test]
		public function testDestroyResource():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "dddd" );
			mgr.destroyResource( "aaa" );
			
		}
		
		[Test]
		public function testGetResource():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "dddd" );
			
			Assert.assertEquals( mgr.getResource("aaa").name, "aaa" );
		}
		
		[Test]
		public function testGetResources():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "http://www.sinaimg.cn/cj/newjs/slg/images/bigmap/1-1.jpg", true );
			mgr.add( "aaa", "dddd" );
			mgr.add( "bbb", "bbb" );
			
			Assert.assertTrue( mgr.getResources( ["aaa", "bbb" ]).length == 2 );
		}
		
		[Test]
		public function testGet_isRunning():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "http://www.sinaimg.cn/cj/newjs/slg/images/bigmap/1-1.jpg", true );
			mgr.load( "aaa" );
			Assert.assertTrue(  mgr.isRunning() );
		}
		
		[Test]
		public function testLoad():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "a/{local}/bg.bmp", true );
			mgr.load( "" );			
		}
		
		[Test]
		public function testSet_local():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.local = "s";
			mgr.add( "aaa", "a/{local}/bg.bmp", true );
			
			Assert.assertEquals( mgr.getResource( "aaa" ).url, "a/s/bg.bmp" );
			
		}
		
		[Test]
		public function testReload():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "ddd", true );
			mgr.reload( ["aaa"] );
		}
		
		[Test]
		public function testRemove():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "ddd", true );
			
			mgr.remove( "aaa" );
			
			Assert.assertNull( mgr.getResource( "aaa" ) ); 
		}
		
		[Test]
		public function testStop():void
		{
			var mgr:ResourceManager = new ResourceManager();
			mgr.add( "aaa", "ddd", true );
			mgr.load( "aaa" );
			mgr.stop( "aaa" );
			
		}
	}
}