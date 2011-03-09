package com.norris.fuzzy.core.sound.event
{
	import com.norris.fuzzy.core.sound.ISounder;
	
	import flash.events.Event;
	
	public class SounderEvent extends Event
	{
		
		public static var SOUND_START:String = "sound_start";
		public static var SOUND_STOP:String = "sound_stop";
		public static var SOUND_END:String = "sound_end";
		public static var SOUND_VOLUMN:String = "sound_volumn";
		
		public var sounder:ISounder;
		
		public function SounderEvent(type:String, sounder:ISounder )
		{
			this.sounder = sounder;
			super( type );
		}
	}
}