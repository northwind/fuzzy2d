package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	import flash.events.Event;
	import models.impl.UnitModel;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class UnitModelComponent extends UnitModel implements IComponent
	{
		public function UnitModelComponent(id:String, attr:Object=null)
		{
			super(id, attr);
		}
		
		public function onSetup():void
		{
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function destroy():void
		{
		}
	}
}