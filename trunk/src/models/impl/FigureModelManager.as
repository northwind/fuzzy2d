package models.impl
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	public class FigureModelManager
	{
		private static var _items:BaseManager = new BaseManager();
		
		public function FigureModelManager()
		{
		}
		
		public static function reg( name:String, figure:FigureModel ) : void
		{
			this._items.reg( name, figure );
		}
		
		public static function unreg( name:String ) :void
		{
			this._items.unreg( name );
		}
		
		public static function get( name:String ) : FigureModel
		{
			return this._items.find( name ) as FigureModel ;
		}
		
	}
}