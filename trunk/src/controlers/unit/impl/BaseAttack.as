package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.events.UnitEvent;
	import controlers.unit.IAttackable;
	import controlers.unit.IFigure;
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
		private var _dirty:Boolean;
		private var _attacking:Boolean;
		private var _range:AttackRange;
		
		public var unit:Unit;
		public var figure:IFigure;
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
			_active = true;
			_range = new AttackRange( unit, model.range, model.rangeType );
		}
		
		public function applyTo( node:Node, callback:Function = null ):void
		{
			if ( _attacking || !this.canApply(node) )	
				return;
			
			_attacking = true;
			_dirty = true;
			
			figure.attackTo( node, callback );
		}
		
		/**
		 * 移动范围 
		 */		
		public function get range():IRange
		{
			_dirty = true;
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
		
		/**
		 * 单点攻击 
		 * @param node
		 * @return 
		 * 
		 */		
		public function canApply( node:Node ):Boolean
		{
			var target:Unit = unit.layer.getUnitByNode( node );
			return _range.contains( node ) && target != null && Unit.isEnemy( target, this.unit );
		}
		
		public function get active() :Boolean
		{
			return _active;
		}

		public function reset() :void
		{
			if ( !_dirty ) return;
			_dirty = false;
			
			_active = true;
			_range.reset();
			_attacking = false;
		}
		
		protected function onStandby(event:Event):void
		{
			//待机后清空移动范围
			_active = true;
			_dirty = false;
		}
		
	}
}