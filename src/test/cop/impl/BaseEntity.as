package impl
{
	public class BaseEntity implements IEntity
	{
		private var components:Array = [];
		
		public function BaseEntity()
		{
		}
		
		public function addComponent(c:IComponent):void
		{
			components.push( c );
		}
		
		public function setup():void
		{
			for( var i:int = 0; i<components.length; i ++ ){
				setupComponent( components[i] as BaseComponent );
			}
			trace( "setup done." );
		}
		
		private function setupComponent( c:BaseComponent ) : void
		{
		}
		
		public function destroy():void
		{
		}
	}
}