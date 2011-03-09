package com.norris.fuzzy.core.sound.impl
{
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.impl.SoundResource;
	import com.norris.fuzzy.core.sound.ISounder;
	
	import flash.media.SoundTransform;
	
	import flexunit.framework.Assert;
	
	public class SounderManagerTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		public var soundResource:IResource = new SoundResource( "lin", "http://slgengine.sinaapp.com//test/天上掉下个林妹妹_new.mp3", true );
		public var soundMgr:SounderManager = new SounderManager();
		public var sounder:Sounder = new Sounder( "main", soundResource );
		
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
			var a:Sounder = new Sounder();
			
			soundMgr.add( a);
			a.name = "aaa";
			soundMgr.add( a);
		}
		
		[Test]
		public function testGet_aviable():void
		{
			Assert.assertTrue( SounderManager.aviable );
		}
		
		[Test]
		public function testCreateSounder():void
		{
			var a:ISounder = soundMgr.create( "aaa" );
			var b:ISounder = soundMgr.create( "bbb", new SoundResource("bbb", "dadfsa" ) );
			
			soundMgr.add( a );
			soundMgr.add( b );
			
		}
		
		[Test]
		public function testDestroy():void
		{
			var a:ISounder = soundMgr.create( "aaa" );
			
			soundMgr.add( a );
			
			soundMgr.destroyResource( "aaa" );
		}
		
		[Test]
		public function testDestroyAll():void
		{
			var a:ISounder = soundMgr.create( "aaa" );
			var b:ISounder = soundMgr.create( "bbb", new SoundResource("bbb", "dadfsa" ) );
			
			soundMgr.add( a );
			soundMgr.add( b );
			
			soundMgr.destroyAll();
		}
		
		[Test]
		public function testDown():void
		{
			soundMgr.add( sounder );
			
			soundMgr.volume( sounder.name, 0.8 );
			
			soundMgr.down( sounder.name, 0.4 );
			
			Assert.assertEquals( soundMgr.get( sounder.name ).volume, 0.4 );
			
		}
		
		[Test]
		public function testGet():void
		{
			var a:ISounder = soundMgr.create( "aaa" );
			
			soundMgr.add( a );
			
			Assert.assertEquals( soundMgr.get( a.name ) , a );
		}
		
		[Test]
		public function testLoops():void
		{
			var a:ISounder = soundMgr.create( "aaa" );
			
			soundMgr.add( a );
			
			soundMgr.loops( "aaa", 2 );
		}
		
		[Test]
		public function testMute():void
		{
			var a:ISounder = soundMgr.create( "aaa" );
			
			soundMgr.add( a );
			
			soundMgr.mute( "aaa" , true );
			
			Assert.assertTrue( soundMgr.get( "aaa" ).mute );
			
		}
		
		[Test]
		public function testMuteAll():void
		{
			soundMgr.muteAll( true );
			
			var a:ISounder = soundMgr.create( "aaa" );
			soundMgr.add( a );
			
			Assert.assertTrue( soundMgr.get( "aaa" ).mute );
		}
		
		[Test]
		public function testPlay():void
		{
			var a:ISounder = soundMgr.create( "aaa" );
			soundMgr.add( a );
			
			soundMgr.play( "aaa" );
			
		}
		
		[Test]
		public function testReplay():void
		{
			soundMgr.add( sounder );
			
			soundMgr.play( sounder.name );
			
			soundMgr.replay( sounder.name );
		}
		
		[Test]
		public function testGet_snapshot():void
		{
			soundMgr.add( sounder );
			
			soundMgr.play( sounder.name );
			
			Assert.assertTrue( SounderManager.snapshot.length > 0 );
		}
		
		[Test]
		public function testStop():void
		{
			soundMgr.add( sounder );
			
			soundMgr.play( sounder.name );
			
			soundMgr.stop( sounder.name );
		}
		
		[Test]
		public function testUp():void
		{
			soundMgr.add( sounder );
			
			soundMgr.play( sounder.name );
			
			soundMgr.up( sounder.name, 0.4 );
			soundMgr.up( sounder.name, 3 );
		}
		
		[Test]
		public function testVolume():void
		{
			soundMgr.add( sounder );
			
			soundMgr.play( sounder.name );
			
			soundMgr.volume( sounder.name, 0.4 );
			
			Assert.assertEquals( soundMgr.get( sounder.name ).volume, 0.4 );
		}
	}
}