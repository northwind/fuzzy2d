package controlers.events
{
	import controlers.Team;
	
	import flash.events.Event;
	
	public class TeamEvent extends Event
	{
		public static const START:String = "team_start";
		public static const OVER:String = "team_over";
		public static const END:String = "team_end";
		
		public var team:Team;
		
		public function TeamEvent(type:String, team:Team )
		{
			super(type, false, false);
			
			this.team = team;
		}
	}
}