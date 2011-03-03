package controlers.core.sound
{
	import controlers.core.resource.impl.SoundResource;
	
	public interface ISound
	{
		function play() : void;
		
		function stop() : void;
		
		function set mute( value:Boolean ) : void;
		
		function get mute() : Boolean;
		
		function set volume( value:uint ) void;
		
		function get volume() : uint;
		
		function set loops( value:uint ) void;
		
		function get loops() : uint;
		
		function replay() : void;
		
		function isStop() : Boolean;
		
		function set dataSource( value:SoundResource ) void;
		
		function get dataSource() : SoundResource;
		
		function destroy() : void;
		
	}
}