package models.impl
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	public class SkillModelManager
	{
		private static var _items:BaseManager = new BaseManager();
		
		public function SkillModelManager()
		{
		}
		
		public static function reg( id:String, skill:SkillModel ) : void
		{
			this._items.reg( id, skill );
		}
		
		public static function unreg( id:String ) :void
		{
			this._items.unreg( id );
		}
		
		public static function get( id:String ) : SkillModel
		{
			return this._items.find( id ) as SkillModel ;
		}
		
	}
}