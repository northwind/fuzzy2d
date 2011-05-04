package controlers
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	import controlers.events.TeamEvent;
	import controlers.events.UnitEvent;
	import controlers.unit.Unit;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import models.impl.TeamModel;

	[Event(name="start", type="controlers.events.TeamEvent")]
	
	[Event(name="over", type="controlers.events.TeamEvent")]
	
	[Event(name="end", type="controlers.events.TeamEvent")]
	/**
	 *管理整个个队伍中的单位，检测回合结束与是否都阵亡等 
	 * @author norris
	 */	
	public class Team extends EventDispatcher
	{
		public var model:TeamModel;
		private var units:BaseManager = new BaseManager();
		
		public function Team( model:TeamModel )
		{
			this.model = model;
		}
		
		public function addUnit( unit:Unit ) : void
		{
			if ( units.has( unit.model.id ) )
				return;
			
			unit.addEventListener(UnitEvent.STANDBY, onUnitStandby );
			unit.addEventListener(UnitEvent.DEAD, onUnitDead );
			
			units.reg( unit.model.id, unit );
		}
		
		public function delUnit( unit:Unit ) : void
		{
			if ( !units.find( unit.model.id ) )
				return;
			
			unit.removeEventListener(UnitEvent.STANDBY, onUnitStandby );
			unit.removeEventListener(UnitEvent.DEAD, onUnitDead );
			
			units.unreg( unit.model.id );
		}
		
		public function start():void
		{
			standbycount = 0;
			for each (var unit:Unit in units.getAll()) {
				unit.restore();				
			}
			
			this.dispatchEvent( new TeamEvent( TeamEvent.START, this ) );
		}
		
		public function end():void
		{
			this.dispatchEvent( new TeamEvent( TeamEvent.END, this ) );
		}
		
		private var standbycount:uint;
		protected function onUnitStandby(event:UnitEvent):void
		{
			standbycount++;
			if ( standbycount >= units.count ){
				this.dispatchEvent( new TeamEvent( TeamEvent.END, this ) );
			}
		}
		
		protected function onUnitDead(event:UnitEvent):void
		{
			units.unreg( event.unit.model.id );
			
			if ( units.count == 0 ){
				this.dispatchEvent( new TeamEvent( TeamEvent.OVER, this ) );
			}
		}
		
	}
}