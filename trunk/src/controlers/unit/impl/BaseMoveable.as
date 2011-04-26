package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	
	import controlers.events.UnitEvent;
	import controlers.unit.IMoveable;
	import controlers.unit.Unit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class BaseMoveable extends BaseComponent implements IMoveable
	{
		//TODO 采用资源管理器统一加载
		[Embed(source='assets/moveto.png')]
		public static const gridClass:Class;
		public static const bitmapData:BitmapData = (new BaseMoveable.gridClass() as Bitmap).bitmapData; 
		
		private var _active:Boolean;
		private var _range:Array;
		
		public var unit:Unit;
		public var model:UnitModelComponent;
		
		public function BaseMoveable()
		{
			super();
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			
			unit.addEventListener(UnitEvent.STANDBY, onStandby );
			_active = true;
		}
		
		public function moveTo(row:int, col:int):void
		{
			_active  = false;
		}
		
		/**
		 * 返回node数组 
		 */		
		public function getMoveRange():Array
		{
			if ( _range == null ){
				_range = unit.layer.tileLayer.getCrossRange( model.row, model.col, model.step );
			}
			
			return _range;
		}
		
		public function showMoveRange():void
		{
			getMoveRange();
			unit.layer.tileLayer.paintNodes( _range, BaseMoveable.bitmapData );
		}
		
		public function hideMoveRange():void
		{
			unit.layer.tileLayer.unpaintNodes();
		}
		
		public function canMove(row:int, col:int):Boolean
		{
			return false;
		}
		
		public function get active() :Boolean
		{
			return _active;
		}
		
		protected function onStandby(event:Event):void
		{
			//待机后清空移动范围
			_range = null;
			_active = true;
		}
		
	}
}