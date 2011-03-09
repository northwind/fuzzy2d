package controlers.core.sound.impl
{
	import controlers.core.manager.impl.BaseManager;
	import controlers.core.sound.ISounder;
	import controlers.core.sound.ISounderManager;
	import controlers.core.resource.IResource;
	import controlers.core.log.Logger;
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	
	
	public class SounderManager extends BaseManager implements ISounderManager
	{
		private var _muted :Boolean = false;
		
		public function SounderManager()
		{
			super();
		}
		
		public static function get aviable() :Boolean
		{
//			return SoundMixer.areSoundsInaccessible();
			return true;
		}
		
		/**
		 * 当前声音波形的快照 
		 * @return 
		 * 
		 */		
		public static function get snapshot() :ByteArray
		{
			if ( !SounderManager.aviable )
				return null; 
			
			var ret:ByteArray = new ByteArray();
			SoundMixer.computeSpectrum( ret, false, 0 );
				
			return ret;	
		}
		
		public function create( name:String, resource:IResource = null ) :ISounder
		{
			var sounder:Sounder = new Sounder( name );
			if ( resource != null )
				sounder.dataSource = resource;	
			
			//新生成的, 也必须是无声的
			if ( _muted )
				sounder.mute = _muted;
			
			//默认添加到管理器
			this.add( sounder );
			
			return sounder;
		}
		
		public function onSetup() : void
		{
		}
		
		public function destroy():void
		{
		}
		
		public function add( sounder:ISounder):void
		{
			if ( sounder == null )
				return;
			if ( sounder.name == "" ){
				Logger.warning( "SoundManager add: sounder.name si null." );
				return;
			}
			
			this.reg( sounder.name, sounder );
		}
		
		public function remove(name:String):void
		{
			this.unreg( name );
		}
		
		public function get(name:String):ISounder
		{
			return this.find( name );
		}
		
		public function play(name:String ):void
		{
			if ( !SounderManager.aviable )
				return;
			
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.play();
		}
		
		public function stop(name:String ):void
		{
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.stop();
		}
		
		public function stopAll() : void
		{
			for each( var item:ISounder in this.getAll() ){
				if ( item.isPlaying() )
					item.stop();
			}
		}
		
		public function mute(name:String , off:Boolean):void
		{
			//单个元素
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.mute = off;	
		}
		
		public function muteAll( off:Boolean ) : void
		{
			//记住
			_muted = off;
			
			for each( var item:ISounder in this.getAll() ){
				if ( item.isPlaying() )
					item.mute = off;
			}
		}
		
		public function up(name:String, value:Number):void
		{
			if ( value > 1 || value < 0 )
				return;
			
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.volume += value;
		}
		
		public function upAll( value:Number ) : void
		{
			if ( value > 1 || value < 0 )
				return;
			
			for each( var item:ISounder in this.getAll() ){
				if ( item.isPlaying() )
					item.volume += value;
			}
		}
		
		public function down(name:String , value:Number):void
		{
			if ( value > 1 || value < 0 )
				return;
			
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.volume -= value;
		}
		
		public function downAll( value:Number ) : void
		{
			if ( value > 1 || value < 0 )
				return;
			
			for each( var item:ISounder in this.getAll() ){
				if ( item.isPlaying() )
					item.volume -= value;
			}
		}
		
		public function volume(name:String , value:Number):void
		{
			if ( value > 1 || value < 0 )
				return;
			
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.volume = value;			
		}
		
		public function volumeAll( value:Number):void
		{
			if ( value > 1 || value < 0 )
				return;
			
			for each( var item:ISounder in this.getAll() ){
				item.volume = value;
			}
		}
		
		public function loops(name:String, times:uint):void
		{
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.loops = times;					
		}
		
		public function replay(name:String ):void
		{
			if ( !SounderManager.aviable )
				return;
				
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.replay();	
		}
		
		public function destroyResource(name:String):void
		{
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.destroy();	
		}
		
		public function destroyAll():void
		{
			for each( var item:ISounder in this.getAll() ){
				item.destroy();
			}
		}
	}
}