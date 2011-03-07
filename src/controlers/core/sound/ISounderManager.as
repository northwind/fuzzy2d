package controlers.core.sound
{
	import controlers.core.resource.IResource;
	
	import flash.utils.ByteArray;

	/**
	 * 声音管理器, 对声音的操作尽量在Manager中完成,便于管理
	 * 
	 * 当name参数可为空时，表示对所有sound进行操作 
	 * @author norris
	 * 
	 */	
	public interface ISounderManager 
	{
		function get aviable() :Boolean;
		
		/**
		 * 当前声音波形的快照 
		 * @return 
		 * 
		 */		
		function get snapshot() :ByteArray;	
		
		/**
		 * 默认添加到Manager中 
		 * @param name
		 * @param resource
		 * @return 
		 * 
		 */		
		function createSounder( name:String, resource:IResource ) :ISounder;
		
		function add( name:String, sounder:ISounder ) : void;
		
		function remove( name:String ) : void;
		
		function get( name:String ) : ISounder;
		
		function play( name:String , transform:SoundTransform = null ) : void;
		
		function stop( name:String = null ) : void;
		
		function up( name:String = null, value:Number ) : void;
		
		function down( name:String = null, value:Number ) : void;
		
		function volume( name:String = null, value:Number ) : void;
		
		function loops( name:String, times : uint ) : void;
		
		function replay( name:String, transform:SoundTransform = null ) : void;
		
		function mute( name:String, off:Boolean ) : void;
		
		function muteAll( off:Boolean ) : void;
		
		function destroy( name:String ) : void;
		
		function destroyAll() : void;
	}
}