package impl
{
	import flash.geom.Point;
	
	import org.osmf.layout.AbsoluteLayoutFacet;

	public class BaseAI extends BaseComponent implements IAIable
	{
		public var attack:IAttackable;
		public var move:IMoveable;
		
		public function BaseAI()
		{
			//TODO: implement function
			super();
		}
		
		public function think():void
		{
			trace( "think" );
			//TODO: implement function
			if ( this.move )
				this.move.moveTo( new Point(10,22) );
			if ( this.attack ){
				this.attack.attack( "b" );
				this.attack.attack( "c" );
			}
		}
		
		public function set attackValue( value:IAttackable ) : void
		{
			//test
			trace("test");
		}
	}
}