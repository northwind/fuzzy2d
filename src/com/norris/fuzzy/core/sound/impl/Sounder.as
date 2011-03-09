package com.norris.fuzzy.core.sound.impl
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.sound.ISounder;
	import com.norris.fuzzy.core.sound.event.SounderEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class Sounder extends EventDispatcher implements ISounder, IDataSource
	{
		private var _name:String = "";
		private var _lastTransform:SoundTransform;
		private var _muted:Boolean = false;
		private var _volume:Number = 0.8;
		private var _loops:uint = 0;
		private var _current:uint = 0;
		private var _length:uint = 0;
		private var _playing:Boolean = false;
		
		private var _resource:IResource;
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		public function Sounder( name:String = null, resource:IResource = null )
		{
			super( null );
			
			this.name = name;
			this.dataSource = resource;
		}
		
		public function set name(value:String):void
		{
			_name =value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function play():void
		{
			//正在播放时
			if ( _playing ){
				return;
			}
			
			if ( _sound ){
				_playing = true;
				
				if ( _lastTransform == null ){
					//如果已置为无声, 则传0 否则传存储的音量值
					_lastTransform = new SoundTransform( this._muted ? 0 : this._volume );
				}
				
				_channel = _sound.play( this._current, 0, _lastTransform );
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete );
				
				_lastTransform = _channel.soundTransform;
				
				this.dispatchEvent( new SounderEvent( SounderEvent.SOUND_START, this ) );
				
				return;
			}
			
		}
		
		private function onSoundComplete( event:Event ) : void
		{
			_playing = false;
			this._current = 0;
			
			this.dispatchEvent( new SounderEvent( SounderEvent.SOUND_END, this ) );
			
			if ( this._loops > 0 ){
				this.replay();
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
		
		private function changeVolume( value:Number ) : void
		{
			//this._channel.soundTransform = new SoundTransform( value );
			if ( _lastTransform == null )
				return;
			
			_lastTransform.volume = value;
			
			this._channel.soundTransform = this._lastTransform;
			
			this.dispatchEvent( new SounderEvent( SounderEvent.SOUND_STOP, this ) );
		}
		
		public function set volume(value:Number) :void
		{
			if ( value > 1 || value < 0 )
				return;
			
			_volume = value;
			
			if ( this._channel != null ){
				changeVolume( value );
			}
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set loops(value:uint) : void
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
		
		public function replay():void
		{
			if ( _sound == null )
				return;
			
			this._playing = false;
			this._channel.stop();
			this._channel = null
			this._current = 0;
			
			if ( this._loops > 0 ){
				this._loops--;
			}
			
			this.play();
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
		
		private function reset() : void
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
			
			if ( value.isFailed() ){
				Logger.warning( "Sounder " + this.name +  " bad dataSource." );
				return;
			}
			
			_resource = value;
			
			_sound = _resource.content as Sound;
			//_length = _sound.length;	//Sound.length 只是当前已下载的长度
			if ( _resource.isFinish() ){
				_length = _sound.length;
			}else
			//动态计算总共长度
			if ( _resource.isLoading() && _resource.bytesTotal > 0 ){
				_length = Math.ceil( _sound.length / (_sound.bytesLoaded / _sound.bytesTotal));
			}
		}
		
		public function get dataSource():IResource
		{
			return _resource;
		}
	}
}