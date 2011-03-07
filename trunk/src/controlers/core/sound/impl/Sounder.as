package controlers.core.sound.impl
{
	import controlers.core.display.IDataSource;
	import controlers.core.resource.IResource;
	import controlers.core.sound.ISounder;
	import controlers.core.sound.event.SounderEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import org.spicefactory.lib.reflect.types.Void;
	
	public class Sounder extends EventDispatcher implements ISounder, IDataSource
	{
		private var _name:String;
		private var _lastTransform:SoundTransform;
		private var _muted:Boolean = false;
		private var _volumn:Number = 1;
		private var _loops:uint = 0;
		private var _current:uint = 0;
		private var _length:uint = 0;
		private var _playing:Boolean = false;
		
		private var _resource:IResource;
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		public function Sounder( name:String = null )
		{
			super( null );
			
			this.name = name;
		}
		
		public function set name(value:String):void
		{
			_name =value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function play(transform:SoundTransform=null):void
		{
			//正在播放时
			if ( _playing ){
				if ( _channel && transform )
					_channel.soundTransform = transform;
				return;
			}
			
			if ( _sound ){
				_playing = true;
				
				_lastTransform = transform;
				_channel = _sound.play( this._current, transform );
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete );
				
				this.dispatchEvent( new SounderEvent( SounderEvent.SOUND_START, this ) );
				
				return;
			}
			
		}
		
		private function onSoundComplete( event:Event ) : Void
		{
			_playing = false;
			this._current = 0;
			
			this.dispatchEvent( new SounderEvent( SounderEvent.SOUND_END, this ) );
			
			if ( this._loops > 0 ){
				this._loops--;
				this.replay( _lastTransform );
			}
		}
		
		public function stop():void
		{
			if ( !_playing || this._channel == null )
				return;
			
			_playing = false;
			//保存上次播放位置
			this._current = this._channel.position;
			this._channel.stop();
			
			this.dispatchEvent( new SounderEvent( SounderEvent.SOUND_STOP, this ) );
		}
		
		public function set mute(value:Boolean):void
		{
			_muted = value;
			
			if ( _channel == null )
				return;
			
			if ( value ){
				//无声
				changeVolume( 0 );
			}else{	
				//有声
				changeVolume( _volume );
			}
		}
		
		public function get mute():Boolean
		{
			return _muted;
		}
		
		private function changeVolume( value:uint ) : void
		{
			this._channel.soundTransform = new SoundTransform( value );
			
			this.dispatchEvent( new SounderEvent( SounderEvent.SOUND_STOP, this ) );
		}
		
		public function set volume(value:Number)
		{
			if ( value > 1 || value < 0 )
				return;
			
			_volumn = value;
			
			if ( this._channel != null ){
				changeVolume( value );
			}
		}
		
		public function get volume():Number
		{
			return _volumn;
		}
		
		public function set loops(value:uint)
		{
			_loops = value;
		}
		
		public function get loops():uint
		{
			return _loops;
		}
		
		public function get length():uint
		{
			return _length;
		}
		
		public function get position():uint
		{
			return _current ;
		}
		
		public function replay( transform:SoundTransform = null ):void
		{
			if ( _sound == null )
				return;
			
			_playing = false;
			this._current = 0;
			
			if ( this._loops > 0 ){
				this._loops--;
			}
			
			this.play( transform );
		}
		
		public function isPlaying():Boolean
		{
			return _playing;
		}
		
		public function destroy():void
		{
			if (  _resource != null )
				_resource.destroy();
		}
		
		private function reset() :Void
		{
			this._playing = false;
			_lastTransform = null;
			_loops = 0;
			_current = 0;
			_length = 0;
			
			_resource = null;
			_sound = null;
			_channel = null;			
		}
		
		public function set dataSource(value:IResource):void
		{
			if ( value == null )
				return;
			
			if ( this._playing ){
				this.stop();
				reset();
			}
			
			_resource = value;
			_sound = _resource.content as Sound;
			//_length = _sound.length;	//Sound.length 只是当前已下载的长度
			_length = Math.ceil( _sound.length / (_sound.bytesLoaded / _sound.bytesTotal));
		}
		
		public function get dataSource():IResource
		{
			return _resource;
		}
	}
}