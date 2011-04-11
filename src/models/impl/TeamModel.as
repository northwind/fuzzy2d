package models.impl
{
	/**
	 * 相同势力为盟军，不同势力即为敌军，相同势力相同队伍才为己方队伍 
	 * @author norris
	 * 
	 */	
	public class TeamModel
	{
		public var faction:int;
		public var team:int;
		public var name:String;
		
		public function TeamModel( name:String, faction:int, team:int  )
		{
			this.name = name;
			this.faction = faction;
			this.team = team;
		}
	}
}