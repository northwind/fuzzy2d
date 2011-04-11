package controlers
{
	public class Skill
	{
		
		public var owner:PlayerModel;			//施放着
		
		private var _frozen:uint;
		private var _avalable:Boolean = false;
		
		public function Skill()
		{
		}
		
		
		/**
		 * 减少了几个回合 
		 * @param count
		 * 
		 */		
		public function unfreeze( count:uint ) : void
		{
			_frozen = Math.max( 0, _frozen - count );
			_avalable = _frozen == 0 ? true : false;
		}
		
		public function get avalable() : Boolean
		{
			return _avalable;
		}		
	}
}