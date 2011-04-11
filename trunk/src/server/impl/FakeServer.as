package server.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Timer;
	import flash.events.*;
	
	import server.*;
	import server.impl.*;
	import server.event.ServerEvent;
	
	public class FakeServer extends EventDispatcher implements IDataServer
	{
		private var _waitfor:Array = [];			//待发送消息队列
		private var _timer:Timer;
		
		public function FakeServer()
		{
			super();
		}
		
		public function config(host:String, port:uint, wait:uint=50, timeout:uint=10000):void
		{
			this._timer = new Timer( wait, 0 );
			this._timer.addEventListener(TimerEvent.TIMER, onTimer );
		}
		
		private function onTimer( event:Event ) : void
		{
			this.send();
		}
		
		public function connect():void
		{
			_timer.start();
			
			this.dispatchEvent( new ServerEvent( ServerEvent.Connect, this ) );
		}
		
		public function close():void
		{
		}
		
		public function send():void
		{
			//重新复制一份
			var tmp:Array = _waitfor.slice( 0, _waitfor.length );
			_waitfor = [];
			
			for each( var req:Object in tmp ){
				handleRequest( req );
				
				if ( req[ "callback" ] is Function )
					(req.callback as Function).call(null, req["rvalue"] );
			}
			
		}
		
		private function handleRequest( req:Object ) :void
		{
			switch( req["type"] )
			{
				case DataRequest.TYPE_Player:			//玩家信息
					req.rtype = 0;
					req.rvalue = {
						name : "李健",
						id	  : "1223333",
						money : 2300,
						screen: "battle",
						record: "2",
						units   : [ 100,101,102,103,104,105 ]
					};
					break;
				
				case DataRequest.TYPE_Record:			//记录信息
					req.rtype = 0;
					req.rvalue = {
						time			: 345678988,			//记录的时间
					
						mapID		: "2222",
						scriptID   : "9999",
						
						teams		:  [{
							faction : 1, team : 100, name : "我军"
						},{
							faction : 1, team : 200, name : "友军"
						},{
							faction : 0, team : 1, name : "敌军"
						}],
						
						victoryN 	: 0, 		//已达到的胜利条件数
						failedN		: 0,      //已达到的失败条件数
						
						units		    : [{
							id: "zhangfei", gx :  6,  gy : 5, range : 1, rangeType : 2, hpMax : 110, step:7, hp : 110, 
							direct : 225,  attack : 20, figure : "assets/zhangfei.swf", symbol : "zhangfei", 
							faction : 0, team : 1,  name : "张飞", level : 1,  visiable : true		
						}],
						
						misfiring	: [ "start", "open", "move" ]			//脚本中已触发过的事件 
						
					};
					break;
				
				case DataRequest.TYPE_Map:			//地图信息
					FakeResponse.createMap( req );
					break;
				
				case DataRequest.TYPE_Script:			//脚本信息
					req.rtype = 0;
					req.rvalue = {
						victoryN 	: 0, 		//需要达到的胜利条件数
						failedN		: 0,      //需要达到的失败条件数
						
						groups		: [{
							id			: "start",	
							event:{
								active	: false,
								type	: 3,
								name	: "battleStart"
							},	
							actions	: [{
								type	   : 4,
								action : "playAnimation",
								params : [ "zhuque", 240, 160 ]
							}]
						},{
							id : "检查胜利2",
							event:{
								active : true,
								type	: 1,
								id	   : "zhangliang",
								name   : "dead"		
							},
							actions : [{
								type: 4,
								action : "checkGoal"
							}]
						},{
							id : "检查失败1",
							event:{
								active : true,
								type	: 1,
								id	   : "caocao",
								name   : "dead"		
							},
							actions : [{
								type: 4,
								action : "checkFail"
							}]
						}]
					};
					break;
				
				case DataRequest.TYPE_Unit:			//角色信息
					FakeResponse.createUnit( req );
					break;
				
				default:
					req.rtype = 1;
			}	
		}
		
		/**
		 *  添加后立即处理 
		 * @param request
		 * 
		 */		
		public function add(request:Object):void
		{
			_waitfor.push( request );
		}
	}
}