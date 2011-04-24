package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	
	import controlers.unit.ISkillable;
	
	import models.impl.SkillModel;
	
	public class BaseSkill extends BaseComponent implements ISkillable
	{
		private var _model:SkillModel;
		
		public function BaseSkill( model:SkillModel )
		{
			super();
			
			this._model = model;
		}
		
		public function get model():SkillModel
		{
			return _model;
		}
		
		public function applyTo(row:int, col:int):void
		{
		}
		
		public function getSkillRange():Array
		{
			return null;
		}
		
		public function canApply(row:int, col:int):Boolean
		{
			return false;
		}
	}
}