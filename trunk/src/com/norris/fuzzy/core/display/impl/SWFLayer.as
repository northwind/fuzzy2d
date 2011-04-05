package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.SWFResource;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SWFLayer extends BaseLayer implements IDataSource
	{
		public var symbol:String;
		public var movieClip:MovieClip;
		
		private var _source:SWFResource;
		
		public function SWFLayer( symbol:String = null )
		{
			super();
			
			this.symbol = symbol;
		}
		
		public function set dataSource(value:IResource):void
		{
			if ( _source != null ){
				_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			}
			
			_source = value as SWFResource ;
			
			if ( _source.isFinish() ){
				onSwfReady();
			}else{
				_source.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_source.load();
			}
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			if ( event.ok )
				onSwfReady();
		}
		
		private function onSwfReady() : void
		{
			if ( this.view.stage )
				onStage();
			else
				this.view.addEventListener(Event.ADDED_TO_STAGE, onStage );
		}
		
		protected function onStage( event:Event = null ) :void
		{
			this.view.removeEventListener(Event.ADDED_TO_STAGE, onStage );
			
			movieClip = _source.getMovieClip( this.symbol );
			this.view.addChild(  movieClip );
		}
		
		public function get dataSource():IResource
		{
			return _source;
		}
	}
}