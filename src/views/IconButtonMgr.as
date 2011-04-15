package views
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;

	public class IconButtonMgr
	{
		private static var _items:BaseManager = new BaseManager();
		
		public static function reg( name:String, iconButton:IconButton ) : void
		{
			if ( name == null || iconButton == null )
				return;
			
			IconButtonMgr._items.reg( name, iconButton );
		}
		
		public static function unreg( name:String) : void
		{
			if ( name == null)
				return;
			
			IconButtonMgr._items.unreg( name );
		}
		
		public static function has( name:String) :Boolean
		{
			if ( name == null)
				return false;
			
			return IconButtonMgr._items.has( name );
		}
		
		public static function get( name:String) :IconButton
		{
			if ( name == null)
				return null;
			
			return IconButtonMgr._items.find( name ) as IconButton;
		}
		
	}
}