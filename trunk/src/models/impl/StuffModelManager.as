package models.impl
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	/**
	 * 物品信息管理器，所有的物品都存放在这里
	 * TODO 采用Template
	 * @author norris
	 */	
	public class StuffModelManager
	{
		private static var _items:BaseManager = new BaseManager();
		
		public static function reg( id:String, stuff:StuffModel ) : void
		{
			_items.reg( id, stuff );
		}
		
		public static function unreg( id:String ) :void
		{
			_items.unreg( id );
		}
		
		public static function has( id:String ) :Boolean
		{
			return _items.has( id );
		}
		
		public static function get( id:String ) :StuffModel
		{
			return _items.find( id ) as StuffModel ;
		}
	}
}