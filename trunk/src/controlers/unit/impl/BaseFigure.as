package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.item.*;
	
	import controlers.unit.IFigure;
	
	import models.impl.FigureModel;
	import models.impl.FigureModelManager;
	import models.impl.UnitModel;
	
	public class BaseFigure extends BaseComponent implements IFigure
	{
		private var _mapItem:IMapItem;
		private var model:UnitModel;
		private var _figureModel:FigureModel;
		
		public function BaseFigure( model:UnitModel )
		{
			super();
			this.model = model;
		}
		
		override public function onSetup() :void
		{
			if ( model == null )
				return;
			
			_figureModel = model.figureModel;
			var itemType:uint = _figureModel.type || MapItemType.IMAGE;
			
			if( itemType == MapItemType.IMAGE ){
				_mapItem = new ImageMapItem();
			} else if( itemType == MapItemType.SWF ){
				_mapItem = new SWFMapItem( model.figureModel.symbol );
			}
			
			_mapItem.define = model.name;
			_mapItem.row = model.row;
			_mapItem.col = model.col;
			_mapItem.offsetX = _figureModel.offsetX;
			_mapItem.offsetY = _figureModel.offsetY;
			_mapItem.cols 	 = _figureModel.cols;
			_mapItem.rows    = _figureModel.rows;
			//unitsLayer中会根据角色类型做出进一步判断
			_mapItem.isWalkable = true;
			_mapItem.isOverlap = false;
		}
		
		public function get mapItem():IMapItem
		{
			return _mapItem;
		}
		
		public function walkTo(row:int, col:int) : void
		{
			
		}
	}
}