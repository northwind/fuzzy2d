package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.SWFResource;
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.events.UnitEvent;
	import controlers.unit.IAttackable;
	import controlers.unit.IFigure;
	import controlers.unit.IRange;
	import controlers.unit.ISkillable;
	import controlers.unit.Unit;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import models.impl.SkillModel;
	
	public class BaseSkill extends BaseComponent implements ISkillable
	{
		private var _active:Boolean;
		private var _dirty:Boolean;
		private var _attacking:Boolean;
		private var _range:AttackRange;
		
		public var unit:Unit;
		public var figure:IFigure;
		public var unitModel:UnitModelComponent;
		
		private var _model:SkillModel;
		private var _resource:SWFResource;
		private var _movie:MovieClip;
		
		public function BaseSkill( model:SkillModel )
		{
			super();
			
			this._model = model;
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			
			unit.addEventListener(UnitEvent.STANDBY, onStandby );
			_active = true;
			_range = new AttackRange( unit, _model.range, _model.rangeType );
			_range.self = true;
			
			_resource = MyWorld.instance.resourceMgr.getResource( _model.src ) as SWFResource;
			if ( _resource == null ){
				_resource = MyWorld.instance.resourceMgr.add( _model.src, _model.src ) as SWFResource;
				_resource.load();
			}
		}
		
		private var _callback:Function;
		public function applyTo( node:Node, callback:Function = null ):void
		{
			if ( _attacking || !this.canApply(node) )	
				return;
			
			_attacking = true;
			_dirty = true;
			_callback = callback;
			
			figure.attackTo( node );
			if ( _resource.isFinish() ){
				playSWF();
			}else{
				_resource.addEventListener( ResourceEvent.COMPLETE, onResourceLoaded );
			}
		}
		
		private function onResourceLoaded( event:ResourceEvent ) : void
		{
			_resource.removeEventListener( ResourceEvent.COMPLETE, onResourceLoaded );
			
			playSWF();
		}
		
		private function playSWF():void
		{
			if ( _movie == null )
				_movie = _resource.getMovieClip();
			
			unit.layer.animationLayer.playMovie( _movie, 
				unit.node.centerX - _movie.width / 2 , unit.node.centerY - _movie.height / 2, onMovieCompleted ); 
		}
		
		private function onMovieCompleted():void
		{
			if ( _callback != null )
				_callback();
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
		 * 单体技能 
		 * @param node
		 * @return 
		 */		
		public function canApply( node:Node ):Boolean
		{
			if ( !_range.contains( node ) )
				return false;
			
			var target:Unit = unit.layer.getUnitByNode( node );
			if ( target == null )
				return false;
			
			var flag:Boolean = false;
			if( _model.effect & EffectType.ENEMY  )
				flag = Unit.isEnemy( target, this.unit );
			
			if ( !flag && _model.effect & EffectType.FRIEND )
				flag = Unit.isFriend( target, this.unit );
			
			if ( !flag && _model.effect & EffectType.BROTHER )
				flag = Unit.isBrother( target, this.unit );
			
			if ( !flag && _model.effect & EffectType.SELF )
				flag = target == this.unit;
			
			return flag;
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
		
		public function get skillModel():SkillModel
		{
			return _model;
		}
		
		protected function onStandby(event:Event):void
		{
			//待机后清空移动范围
			_active = true;
			_dirty = false;
		}
	}
}