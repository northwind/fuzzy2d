package controlers.core.sound
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 声音管理器
	 * 当name参数可为空时，表示对所有sound进行操作 
	 * @author sina
	 * 
	 */	
	public interface ISoundManager extends IEventDispatcher
	{
		function add( name:String, sounder:ISound ) : void;
		
		function remove( name:String ) : void;
		
		function getSound( name:String ) : ISound;
		
		function play( name:String ) : void;
		
		function stop( name:String = null ) : void;
		
		function mute( name:String = null , off:Boolean ) : void;
		
		function up( name:String = null, value:uint ) : void;
		
		function down( name:String = null, value:uint ) : void;
		
		function volume( name:String = null, value:uint ) : void;
		
		function loops( name:String, times : uint ) : void;
		
		function replay( name:String ) : void;
		
		function destroy( name:String ) : void;
		
		function destroyAll() : void;
	}
}