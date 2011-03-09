package com.norris.fuzzy.core.sound
{
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.cop.IComponent;
	
	import flash.utils.ByteArray;
	import flash.media.SoundTransform;
	
	/**
	 * 声音管理器, 对声音的操作尽量在Manager中完成,便于管理
	 * 
	 * 当name参数可为空时，表示对所有sound进行操作 
	 * @author norris
	 * 
	 */	
	public interface ISounderManager extends IComponent
	{
		/**
		 * 默认添加到Manager中 
		 * @param name
		 * @param resource
		 * @return 
		 * 
		 */		
		function create( name:String, resource:IResource = null ) :ISounder;
		
		function add( sounder:ISounder ) : void;
		
		function remove( name:String ) : void;
		
		function get( name:String ) : ISounder;
		
		function play( name:String ) : void;
		
		function stop( name:String ) : void;
		
		function stopAll() : void;
		
		function up( name:String, value:Number ) : void;
		
		function upAll( value:Number ) : void;
		
		function down( name:String, value:Number ) : void;
		
		function downAll( value:Number ) : void;
		
		function volume( name:String, value:Number ) : void;
		
		function volumeAll( value:Number ) : void;
		
		function loops( name:String, times : uint ) : void;
		
		function replay( name:String ) : void;
		
		function mute( name:String, off:Boolean ) : void;
		
		function muteAll( off:Boolean ) : void;
		
		function destroyResource( name:String ) : void;
		
		function destroyAll() : void;
	}
}