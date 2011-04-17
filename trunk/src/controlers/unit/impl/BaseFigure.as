package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.astar.Path;
	import com.norris.fuzzy.map.item.*;
	
	import controlers.events.UnitEvent;
	import controlers.layers.TileLayer;
	import controlers.layers.UnitsLayer;
	import controlers.unit.IFigure;
	import controlers.unit.Unit;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import models.impl.FigureModel;
	import models.impl.FigureModelManager;
	import models.impl.UnitModel;
	
	import server.IDataServer;
	
	[Event(name="complete", type="flash.events.event")]
	
	public class BaseFigure extends BaseComponent implements IFigure
	{
		private var _mapItem:SWFMapItem;
		private var model:UnitModel;
		private var _figureModel:FigureModel;
		private var _resource:IResource;
		private var unit:Unit;
		private var timer:Timer;
		private var currentNode:Node;
		private var nextNode:Node;
		
		public function BaseFigure( model:UnitModel, unit:Unit )
		{
			super();
			this.model = model;
			this.unit = unit;
//			this.currentNode = 
			
			this.timer = new Timer( 100, 1 ); 
			this.timer.addEventListener(TimerEvent.TIMER, onTimer );
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
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
		
		private var onWalkPathCallback:Function;
		public function walkPath( path:Path, callback:Function = null ) : void
		{
			nodes = path.nodes;
			//无路径或者只有自己所在的单元格直接返回
			if ( nodes.length <= 1 ){
				if ( callback != null )
					callback.call();
				return;
			}
			
			onWalkPathCallback = callback;
			currentN = 1;
			currentNode = nodes[1] as Node;
			nextNode      = nodes[1] as Node;
			
			this.walkTo( nodes[1], onNodeCallback );
		}
		
		private var currentN:int;
		private var nodes:Array;
		private function onNodeCallback() : void 
		{
			if ( ++currentN < nodes.length ){
				currentNode = nodes[ currentN ] as Node;
				this.walkTo( nodes[ currentN ], onNodeCallback );
			}else{
				if ( onWalkPathCallback != null )
					onWalkPathCallback.call();
				
				unit.dispatchEvent( new UnitEvent( UnitEvent.MOVE_OVER, this.unit ) );
			}
		}
		
		private var nodeCallback:Function;
		private var node:Node;
		private function walkTo( node:Node, callback:Function = null ) : void
		{
			var direct:String = BaseFigure.getDirect(  node, node );
			var fn:String = "turn" + direct;
			try
			{
				_mapItem.view[ fn ]();	
			}
			catch(error:Error) {
				Logger.error( this.model.name + " has no function : " +  fn );
			}
			
			this.node = node;
			this.nodeCallback = callback;
			
			this.timer.start();
		}
		
		/**
		 * 计算角色朝向 
		 * @param from
		 * @param to
		 * @return 
		 * 
		 */		
		public static function getDirect( from:Node, to:Node ) :String
		{
			return "RightDown";
		}
		
		protected function onTimer(event:Event):void
		{
			this._mapItem.row = currentNode.row;
			this._mapItem.col = currentNode.col;
			
			unit.dispatchEvent( new UnitEvent( UnitEvent.MOVE, this.unit ) );
		}
		
		protected function onTimerComplete(event:Event):void
		{
			if ( nodeCallback != null )
				nodeCallback.call();
		}
		
		
	}
}