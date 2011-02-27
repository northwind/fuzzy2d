package impl
{
	import flash.geom.Point;
	
	import org.osmf.layout.AbsoluteLayoutFacet;

	public class BaseAI extends BaseComponent implements IAIable
	{
		public var attack:IAttackable;
		public var move:IMoveable;
		public var command:ICommandable;
		
		public function BaseAI()
		{
			super();
		}
		
		public override function onSetup() : void
		{
			if ( this.command ){
				this.command.reg( "auto", this.think ); 
			}		
		}
		
		public function think( callback:Function = null ):void
		{
			trace( "think" );
			if ( this.move )
				this.move.moveTo( new Point(10,22) );
			if ( this.attack ){
				this.attack.attack( "b" );
				this.attack.attack( "c" );
			}
			
			if ( callback != null )
				callback.call();
		}
		
		[Multiple]
		public function set attackValue( value:IAttackable ) : void
		{
			//test
			trace("BaseAI set attackValue success");
		}
		
	}
}