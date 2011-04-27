package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	
	import controlers.events.UnitEvent;
	import controlers.unit.IMoveable;
	import controlers.unit.IRange;
	import controlers.unit.Unit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class BaseMove extends BaseComponent implements IMoveable
	{
		//TODO 采用资源管理器统一加载
		[Embed(source='assets/moveto.png')]
		public static const gridClass:Class;
		public static const bitmapData:BitmapData = (new gridClass() as Bitmap).bitmapData; 
		
		private var _active:Boolean;
		private var _range:MoveRange;
		
		public var unit:Unit;
		public var model:UnitModelComponent;
		
		public function BaseMove()
		{
			super();
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			
			unit.addEventListener(UnitEvent.STANDBY, onStandby );
			_active = true;
			_range = new MoveRange( unit );
		}
		
		public function moveTo(row:int, col:int):void
		{
			_active  = false;
		}
		
		/**
		 * 移动范围 
		 */		
		public function get range():IRange
		{
			_range.measure();
			
			return _range;
		}
		
		public function showRange():void
		{
			unit.layer.tileLayer.paintRange( range, BaseMove.bitmapData );
		}
		
		public function hideRange():void
		{
			unit.layer.tileLayer.clear();
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
			_range.reset();
			_active = true;
		}
		
	}
}