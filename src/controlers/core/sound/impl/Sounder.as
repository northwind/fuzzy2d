package controlers.core.sound.impl
{
	import controlers.core.display.IDataSource;
	import controlers.core.resource.IResource;
	import controlers.core.sound.ISounder;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.SoundTransform;
	
	public class Sounder extends EventDispatcher implements ISounder, IDataSource
	{
		private var _name:String;
		private var _transform:SoundTransform;
		private var _muted:Boolean = false;
		private var _volumn:Number = 1;
		private var _loops:uint = 1;
		private var _playing:Boolean = false;
		private var _resource:IResource;
		
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
		}
		
		public function stop():void
		{
			_playing = false;
		}
		
		public function set mute(value:Boolean):void
		{
			_muted = value;
			//无声
		}
		
		public function get mute():Boolean
		{
			return _muted;
		}
		
		public function set volume(value:Number)
		{
			_volumn = value;
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
			return 0;
		}
		
		public function get position():uint
		{
			return 0;
		}
		
		public function replay():void
		{
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
		
		public function set dataSource(value:IResource):void
		{
			_resource = value;
		}
		
		public function get dataSource():IResource
		{
			return _resource;
		}
	}
}