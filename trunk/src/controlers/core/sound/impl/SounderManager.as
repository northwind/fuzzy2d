package controlers.core.sound.impl
{
	import controlers.core.manager.impl.BaseManager;
	import controlers.core.sound.ISounder;
	import controlers.core.sound.ISounderManager;
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	
	public class SounderManager extends BaseManager implements ISounderManager
	{
		private var _muted :Boolean = false;
		private var _aviable:Boolean = true;
		
		public function SounderManager()
		{
			super();
			
			_aviable = SoundMixer.areSoundsInaccessible();
		}
		
		public function get aviable() :Boolean
		{
			return _aviable;
		}
		
		public function get snapshot() :ByteArray
		{
			if ( !_aviable )
				return null; 
			
			var ret:ByteArray = new ByteArray();
			SoundMixer.computeSpectrum( ret, false, 0 );
				
			return ret;	
		}
		
		public function createSounder( name:String, resource:IResource ) :Sounder
		{
			var sounder:Sounder = new Sounder( name );
			sounder.dataSource = sounder;	
			
			//新生成的, 也必须是无声的
			if ( _muted )
				sounder.mute = _muted;
				
			return sounder;
		}
		
		public function add(name:String, sounder:ISounder):void
		{
			this.reg( name, sounder );
		}
		
		public function remove(name:String):void
		{
			this.unreg( name );
		}
		
		public function get(name:String):ISounder
		{
			return this.find( name );
		}
		
		public function play(name:String , transform:SoundTransform = null ):void
		{
			if ( !_aviable )
				return;
			
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.play( transform );
		}
		
		public function stop(name:String=null):void
		{
			//对所有元素操作
			if ( name == null ){
				
				for each( var item:ISounder in this.getAll() ){
					if ( item.isPlaying() )
						item.stop();
				}
				
				return;
			}
			
			//单个元素
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.stop();
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
		
		public function up(name:String=null, value:Number):void
		{
			//对所有元素操作
			if ( name == null ){
				
				for each( var item:ISounder in this.getAll() ){
					if ( item.isPlaying() )
						item.volume += value;
				}
				
				return;
			}
			
			//单个元素
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				item.volume += value;
		}
		
		public function down(name:String=null, value:Number):void
		{
			//对所有元素操作
			if ( name == null ){
				
				for each( var item:ISounder in this.getAll() ){
					if ( item.isPlaying() )
						item.volume -= value;
				}
				
				return;
			}
			
			//单个元素
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				item.volume -= value;
		}
		
		public function volume(name:String=null, value:Number):void
		{
			//对所有元素操作
			if ( name == null ){
				
				for each( var item:ISounder in this.getAll() ){
					item.volume = value;
				}
				
				return;
			}
			
			//单个元素
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.volume = value;			
		}
		
		public function loops(name:String, times:uint):void
		{
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.loops = times;					
		}
		
		public function replay(name:String, transform:SoundTransform = null):void
		{
			if ( !_aviable )
				return;
				
			var sounder:ISounder = this.find( name ) as ISounder;
			if ( sounder != null )
				sounder.replay();	
		}
		
		public function destroy(name:String):void
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