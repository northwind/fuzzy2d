package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.item.*;
	
	import controlers.unit.IFigure;
	
	import flash.display.Shape;
	import flash.events.Event;
	
	import models.impl.FigureModel;
	import models.impl.FigureModelManager;
	import models.impl.UnitModel;
	
	import server.IDataServer;
	
	import views.UnitMapItem;
	
	
	[Event(name="complete", type="flash.events.event")]
	
	public class BaseFigure extends BaseComponent implements IFigure
	{
		private var _mapItem:SWFMapItem;
		private var model:UnitModel;
		private var _figureModel:FigureModel;
		private var _resource:IResource;
		
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
			if ( _figureModel.type != MapItemType.SWF ){
				Logger.error( this.model.name + "'s type != MapItemType.SWF"  );
				return;
			}
			
			_mapItem = new SWFMapItem( model.figureModel.symbol );
			//				_mapItem = new UnitMapItem( model.figureModel.symbol );
			
			//加载资源
			_resource = MyWorld.instance.resourceMgr.getResource( _figureModel.url );
			if ( _resource == null ){
				_resource = MyWorld.instance.resourceMgr.add( _figureModel.url, _figureModel.url, true );
			}
			//没有下载的使用默认显示
			if ( _resource.isFinish() ){
				setMapItem( _figureModel );
				_mapItem.dataSource = 	_resource;
			}else{
				setMapItem( FigureModelManager.defaultFigureModel );
				_mapItem.dataSource	= MyWorld.instance.resourceMgr.getResource( "defaultFigure" );
				
				_resource.addEventListener( ResourceEvent.COMPLETE, onResourceComplete );
				_resource.load();
			}
			
		}
		
		private function setMapItem( f:FigureModel ) :void
		{
			_mapItem.define = model.name;
			_mapItem.row = model.row;
			_mapItem.col = model.col;
			
			_mapItem.offsetX = f.offsetX;
			_mapItem.offsetY = f.offsetY;
			_mapItem.cols 	 = f.cols;
			_mapItem.rows    = f.rows;
			_mapItem.symbol = f.symbol;
			
			//unitsLayer中会根据角色类型做出进一步判断
			_mapItem.isWalkable = true;
			_mapItem.isOverlap = false;
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_resource.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			
			setMapItem( _figureModel );
			_mapItem.dataSource = _resource;
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
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