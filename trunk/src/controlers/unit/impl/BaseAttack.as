package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	
	import controlers.events.UnitEvent;
	import controlers.unit.IAttackable;
	import controlers.unit.IRange;
	import controlers.unit.Unit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class BaseAttack extends BaseComponent implements IAttackable
	{
		//TODO 采用资源管理器统一加载
		[Embed(source='assets/attack.png')]
		public static const gridClass:Class;
		public static const bitmapData:BitmapData = (new gridClass() as Bitmap).bitmapData; 
		
		private var _active:Boolean;
		private var _range:AttackRange;
		
		public var unit:Unit;
		public var model:UnitModelComponent;
		
		public function BaseAttack()
		{
			super();
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			
			unit.addEventListener(UnitEvent.STANDBY, onStandby );
			unit.addEventListener(UnitEvent.MOVE_OVER, onMoveOver );
			_active = true;
			_range = new AttackRange( unit );
		}
		
		public function attackTo( to:Unit ):void
		{
			
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
			unit.layer.tileLayer.paintRange( range, BaseAttack.bitmapData );
		}
		
		public function hideRange():void
		{
			unit.layer.tileLayer.clear();
		}
		
		public function canAttack( to:Unit ):Boolean
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
		
		protected function onMoveOver(event:Event):void
		{
			_range.reset();
		}
		
	}
}