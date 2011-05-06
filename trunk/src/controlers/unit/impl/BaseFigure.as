package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.item.MapItemType;
	import com.norris.fuzzy.map.item.SWFMapItem;
	
	import controlers.events.UnitEvent;
	import controlers.layers.TileLayer;
	import controlers.layers.UnitsLayer;
	import controlers.unit.IFigure;
	import controlers.unit.Unit;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import models.impl.FigureModel;
	import models.impl.FigureModelManager;
	import models.impl.UnitModel;
	
	[Event(name="complete", type="flash.events.event")]
	
	public class BaseFigure extends BaseComponent implements IFigure
	{
		private var _mapItem:SWFMapItem
		private var _figureModel:FigureModel;
		private var _resource:IResource;
		
		private var lastDirect:uint = 7;		//默认都是左下
		
		public var model:UnitModelComponent;
		public var unit:Unit;
		
		public function BaseFigure()
		{
			super();
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}

		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			
			if ( model == null )
				return;
			
			_figureModel = model.figureModel;
			if ( _figureModel.type != MapItemType.SWF ){
				Logger.error( this.model.name + "'s type != MapItemType.SWF"  );
				return;
			}
			
			_mapItem = new SWFMapItem( model.figureModel.symbol );
			
			//加载资源
			_resource = MyWorld.instance.resourceMgr.getResource( _figureModel.url );
			if ( _resource == null ){
				_resource = MyWorld.instance.resourceMgr.add( _figureModel.url, _figureModel.url, true );
			}
			//没有下载的使用默认显示
			if ( _resource.isFinish() ){
				setMapItem( _figureModel );
				_mapItem.dataSource = 	_resource;
				
				onResourceComplete();
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
		
		private function onResourceComplete( event:ResourceEvent = null ) : void
		{
			if ( event != null ){
				_resource.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				setMapItem( _figureModel );
				_mapItem.dataSource = _resource;
			}
			
			(_mapItem.view as MovieClip ).mouseEnabled =false;
			(_mapItem.view as MovieClip ).mouseChildren = false;
			//展示正确朝向
			var temp:uint = lastDirect;
			lastDirect = 9999;
			turnTo( temp );
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get mapItem():IMapItem
		{
			return _mapItem;
		}
		
		public function get direct():uint
		{
			return this.lastDirect;
		}
		
		public function get avatar():MovieClip
		{
			try
			{
				return _mapItem.view[ "getAvatar" ]() as MovieClip;	
			}
			catch(error:Error) {
				Logger.error( this.model.name + " has no function : avatar." );
			}
			return new MovieClip();
		}
		
		public function gray() : void
		{
			try
			{
				_mapItem.view[ "gray" ]();	
			}
			catch(error:Error) {
				Logger.error( this.model.name + " has no function : gray." );
			}
		}
		
		//高亮  统一采用底部增加亮圈的方式
		public function highlight() : void
		{
			
		}
		
		public function faceTo( node:Node, from:Node = null ) : void
		{
			var direct:uint = BaseFigure.getDirect( from || unit.node , node );
			turnTo( direct );
		}
		
		public function turnTo( direct:uint ):void
		{
			if ( lastDirect != direct ){
				lastDirect = direct;
				
				var fn:String = "turn" + direct;
				try
				{
					_mapItem.view[ fn ]();	
				}
				catch(error:Error) {
					Logger.error( this.model.name + " has no function : " +  fn );
				}
			}
		}
		
		public function attackTo( node:Node = null, callback:Function = null ) : void
		{
			
		}		
		/**
		 * 计算9宫格方向 
		 * [0,1,2,
			3,4,5,
			6,7,8]
			  0
		    3    1
		  6    4   2
		     7   5
			   8
		 */		
		public static function getDirect( from:Node, to:Node ) :uint
		{
			var diffX:int = from.row - to.row,
				diffY:int = from.col - to.col;
			
			return (diffX > 0 ? 0 : diffX< 0 ? 2 : 1 ) + 
					(diffY > 0 ? 0 : diffY< 0 ? 6 : 3 );
		}

	}
}