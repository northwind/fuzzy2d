package controlers.core.sound
{
	import controlers.core.resource.impl.SoundResource;
	
	import flash.events.IEventDispatcher;
	import flash.media.SoundTransform;
	
	[Event(name="sound_start", type="controlers.core.sound.event.SounderEvent")]
	
	[Event(name="sound_stop", type="controlers.core.sound.event.SounderEvent")]
	
	[Event(name="sound_end", type="controlers.core.sound.event.SounderEvent")]
	
	[Event(name="sound_volumn", type="controlers.core.sound.event.SounderEvent")]
	
	/**
	 * 封装对声音元素的操作
	 * @author norris
	 * 
	 */	
	public interface ISounder extends IEventDispatcher
	{
		function set name( value:String ) : void;
		
		function get name() : String;
		
		/**
		 * 不允许从中间某个位置播放 
		 * @param transform
		 * 
		 */		
		function play() : void;
		
		/**
		 *  如果声音文件仍在加载过程中，则只是暂时性的暂停，会在下一帧继续播放 
		 *  完全停止需要使用Sound.close()
		 */		
		function stop() : void;
		
		function set mute( value:Boolean ) : void;
		
		function get mute() : Boolean;
		
		function set volume( value:Number ) : void;
		
		function get volume() : Number;
		
		function set loops( value:uint ) : void;
		
		function get loops() : uint;
		
		function get length() :uint;
		
		function get position() :uint;
		
		function replay() : void;
		
		function isPlaying() : Boolean;
		
		function destroy() : void;
		
	}
}