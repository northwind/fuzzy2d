package models.impl
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	import models.event.ModelEvent;
	import models.impl.FigureModel;
	
	public class FigureModelManager
	{
		private static var _items:BaseManager = new BaseManager();
		
		public static var defaultFigureModel:FigureModel;
		public static function init( callback:Function = null ) : void
		{
			var f:FigureModel = new FigureModel( "0" );
			if ( callback != null )
				f.addEventListener(ModelEvent.COMPLETED, callback );
			f.loadData();
			
			FigureModelManager._items.reg( f.id, f );
			
			FigureModelManager.defaultFigureModel = f;
		}
		
		public static function reg( name:String, figure:FigureModel ) : void
		{
			FigureModelManager._items.reg( name, figure );
		}
		
		public static function unreg( name:String ) :void
		{
			FigureModelManager._items.unreg( name );
		}
		
		public static function has( name:String ) :Boolean
		{
			return FigureModelManager._items.has( name );
		}
		
		public static function get( name:String ) : FigureModel
		{
			return FigureModelManager._items.find( name ) as FigureModel;
		}
		
	}
}