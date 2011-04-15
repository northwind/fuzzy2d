package controlers.unit
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import models.impl.PlayerModel;
	import models.impl.SkillModel;
	import models.impl.SkillModelManager;
	import models.impl.UnitModel;
	
	public class Skill extends EventDispatcher
	{
		public var id:String;
		public var level:uint;
		public var owner:UnitModel;
		public var model:SkillModel;
		
		public function Skill( id:String, level:uint, owner:UnitModel )
		{
			super(null);
			
			this.id = id;
			this.level = level;
			this.owner = owner;
			this.model = SkillModelManager.get( id ); 
		}
	}
}