package models.impl
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;

	/**
	 * 相同势力为盟军，不同势力即为敌军，相同势力相同队伍才为己方队伍 
	 * @author norris
	 * 
	 */	
	public class TeamModel extends BaseModel
	{
		public var faction:int;
		public var team:int;
		public var name:String;
		public var members:BaseManager = new BaseManager();
		
		public function TeamModel( name:String, faction:int, team:int  )
		{
			this.name = name;
			this.faction = faction;
			this.team = team;
		}
		
		public function addUnitModel( unitModel:UnitModel ) : void
		{
			members.reg( unitModel.id, unitModel );
		}
		
		public function delUnitModel( unitModel:UnitModel ) : void
		{
			members.unreg( unitModel.id );
		}
		
	}
}