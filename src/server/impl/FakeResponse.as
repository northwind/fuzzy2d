package server.impl
{
	import com.norris.fuzzy.map.item.MapItemType;
	import models.impl.*;
	import controlers.unit.impl.*;
	
	public class FakeResponse
	{
		public static function createMap( req:Object ) : void
		{
			req.rtype = 0;
			req.rvalue = {
				name : "汜水关之战",
				cellXNum : 20,
				cellYNum : 20,
				oX		: 	50,		oY	:   50,
//				oX : 0, oY: 0,
				
					bg		: {
						src   : "assets/bgtest8.png",
						oT   : 50,
						oL	: 50,
						oR   : 50,
						oB   : 50,
						color : "0x333333"
					},
					
					sound	: {
						src   :  "assets/ddd.mp3",
						loop : true
					},
					
					//不可行走
					blocks : [{
						r:6, c:24
					},{
						r:6, c:25
					},{
						r:9, c:25
					},{
						r:10, c:26
					},{
						r:11, c:27
					}],
					//渲染场景
//					items   : [],
					items	: [{
						d : "npc2",	r : 6, c : 20
					},{
						d : "train", r: 5, c : 15
					},{
						d : "train", r: 5, c : 25
					},{
						d : "house1", r: 13, c : 26
					},{
						d : "house1", r: 8, c : 21
					},{
						d : "house1", r: 8, c : 19
					},{
						d : "house1", r: 10, c : 22
					},{
						d : "house1", r: 12, c : 22
					},{
						d : "house1", r: 12, c : 21
					},{
						d : "garden", r: 10, c : 17
					},{
						d : "garden", r: 10, c : 21
					},{
						d : "tree", r: 11, c : 23
					},{
						d : "tree", r: 11, c : 20
					},{
						d : "grass3", r: 9, c : 23
					},{
						d : "grass3", r: 8, c : 22
					},{
						d : "grass3", r: 7, c : 22
					}],
					//1 = true 0 = false
					//改用简写节省空间
					//rs = rows 占的行数 cs = cols 占的列数 oc = offsetX, oY=offsetY, o = overlap, w=walkable, s=src
					// type: 1 静态 2 动态  sb = symbol 
//					defines : []
					defines	: [{
						id	: "tree", s : "assets/tree.png", oX :18, oY:0, rs:1, cs:1, w : 0, o : 0,
						type : 1
					},{
						id	: "train", s : "assets/train.png", oX :30, oY:-13, rs:1, cs:4, w : 0, o : 0,
						type : 1
					},{
						id	: "garden", s : "assets/garden.png", oX :13, oY:-5, rs:2, cs:2, w : 0, o : 0,
						type : 1
					},{
						id	: "busstation", s : "assets/busstation.png", oX :0, oY:0, rs:1, cs:2, w : 0, o : 0,
						type : 1
					},{
						id	: "house1", s : "assets/house1.png", oX :8, oY:-3, rs:2, cs:1, w : 0, o : 0,
						type : 1
					},{
						id	: "grass3", s : "assets/grass3.png", oX :10, oY:0, rs:1, cs:1, w : 1, o : 1,
						type : 1
					},{
						id	: "npc2", s : "assets/zhangfei.swf",  oX :-8, oY:15, rs:1, cs:1, w : 0, o : 1,
						type : 2, sb : "ZhangFei"
					}]
			};			
		}
		
		public static function createUnit( req:Object ) : void
		{
			req.rtype = 0;
			var id :uint = parseInt( req.data.id );
			switch( id )
			{
				case 1:
					req.rvalue = {
						id	 :  1,
						na   : "张飞",
						fg   : 1,			//形象
						lv	 : 1,  					//级别
						
						bH : 100,					//自身属性血量 bodyHP
						fH : 50,					//装备加成    fixHP
						
						bA : 50,
						fA : 25,
						
						sk : [ { id : 1, lv : 1 }, 
							{ id : 2, lv : 2 } ],				//技能表
						
						sf : [ { id:1, n : 6 } ],			    //物品
						
						rg  : 4,					//attack range
						rt  : RangeType.SPREAD,					//attack rangeType
						st  : 5,					//move step				
						
						rs  : 1,					//rows
						cs	: 1						//cols
					};
					break;
				case 2:
					req.rvalue = {
						id	 :  2,
						na   : "剑士",
						fg   : 2,			//形象
						lv	 : 1,  					//级别
						
						bH : 100,					//自身属性血量 bodyHP
						fH : 50,					//装备加成    fixHP
						
						bA : 50,
						fA : 25,
						
						sk : [ { id : 1, lv : 1 }, 
							{ id : 2, lv : 2 } ],				//技能表
						
						sf : [ { id:1, n : 6 } ],			    //物品
						
						rg  : 2,					//range
						rt  : RangeType.LINE,					//rangeType
						st  : 5,					//step				
						
						rs  : 1,					//rows
						cs	: 1						//cols
					};					
					break;
			}

		}

		public static function createFigure( req:Object ) : void
		{
			req.rtype = 0;
			var id :uint = parseInt( req.data.id );
			switch( id )
			{
				case 0:
					req.rvalue = {
						id	 :  0,
						tp	 : MapItemType.SWF,
						fg   : "assets/systemResource.swf",			//地址
						sb  : "defaultFigure",
						
						oX   : 0, 
						oY   : 0,
							
						rs  : 1,					//rows
						cs	: 1						//cols
					};
					break;
				case 1:
					req.rvalue = {
						id	 :  1,
						tp	 : MapItemType.SWF,
							fg   : "assets/zhangfei.swf",			//地址
							sb   : "ZhangFei",			//symbol
							
							oX   :-8, 
							oY   :15,
							
							w : 0, 
							o : 1,
							
							rs  : 1,					//rows
							cs	: 1						//cols
					};					
					break;
				case 2:
					req.rvalue = {
						id	 :  2,
						tp	 : MapItemType.SWF,
							fg   : "assets/swordman.swf",			//地址
							sb   : "swordman",			//symbol
							
							oX   :5, 
							oY   :-5,
							
							w : 0, 
							o : 1,
							
							rs  : 1,					//rows
							cs	: 1						//cols
					};					
					break;
			}
		}
		
		public static function createSkill( req:Object ) : void
		{
			req.rtype = 0;
			var id :uint = parseInt( req.data.id );
			switch( id )
			{
				case 1:
					req.rvalue = {
						id	: 1,
						na	: "圣光",
						de	: "恢复HP",
						im	: "assets/smile_grin_48.png",
						an  : "redStar",
						rg  : 1,
						rt  : 1,
						ef  : 3,
						ct  : 1,
						ln  : {}
					};
					break;
				
				case 2:
					req.rvalue = {
						id		: 2,
						na	: "风暴",
						de	: "单体减伤",
						im	   	: "assets/smile_sad_48.png",
						rg	: 4, 			
						rt : 2,     
						an : "storm",	
						ef	: 7,
						ln : {}
					};
					break;
				default:
					break;
			}
		}
		
		public static function createStuff( req:Object ) : void
		{
			req.rtype = 0;
			var id :uint = parseInt( req.data.id );
			switch( id )
			{
				case 1:
					req.rvalue = {
					id	: 1,
					na	: "smallblood",
					de	: "恢复HP",
					im	: "assets/add_48.png",
					an  : "redStar",
					rg  : 1,
					rt  : 1,
					ef  : EffectType.SELF,
					ct  : 1,
					ln  : {}
				};
					break;
				
				case 2:
				req.rvalue = {
					id		: 2,
					na	: "bigblood",
					de	: "群体恢复HP",
					im	   	: "assets/add_48.png",
					rg	: 4, 			
					rt : 2,     
					an : "storm",	
					ef	: EffectType.FRIEND,
					ct : 3,
					ln : {}
				};
				break;
				default:
					break;
			}
		}
		
		public static function createRecord( req:Object ) : void
		{	
			req.rtype = 0;
			req.rvalue = {
				time			: 345678988,			//记录的时间
				
				mapID		: "2222",
				scriptID   : "9999",
				
				teams		:  [{
					fa : 1, tm : 100, na : "我军"
				},{
					fa : 1, tm : 200, na : "友军"
				},{
					fa : 0, tm : 1, na : "敌军"
				}],
				
				victoryN 	: 0, 		//已达到的胜利条件数
				failedN		: 0,      //已达到的失败条件数
				
				//r = row, c = col d= direct
				//fa = faction 势力	tm = team 队伍  v = visiable 是否可见  1可见 0不可见 oH : 50,					
				//cH = currentHP 当前血量  oH = offsetHP 技能加成   
				units		    : [{
					id: 1,  r :  16,  c : 20,  cH : 110, oH : 30, cA : 20, oA:2,  d : 225,  fa : 0, tm : 1,   v : 1		
				},{
					id: 2,  r :  20,  c : 20,  cH : 110, oH : 30, cA : 20, oA:2,  d : 225,  fa : 0, tm : 200,   v : 1		
				},{
					id: 3,  r :  15,  c : 21,  cH : 110, oH : 30, cA : 20, oA:2,  d : 225,  fa : 0, tm : 1,   v : 1,
					na : "杂兵1", fg: "1", lv:2, rg  : 3, rt : 6 , st:4, bH : 100, fH : 50, bA : 50, fA : 25
				},{
					id: 4,  r :  20,  c : 1,  cH : 110, oH : 30, cA : 20, oA:2,  d : 225,  fa : 0, tm : 1,   v : 1,
					na : "杂兵2", fg: "1", lv:2, rg  : 3, rt : 4, st:4, bH : 100, fH : 50, bA : 50, fA : 25
				},{
					id: 5,  r :  38,  c : 20,  cH : 110, oH : 30, cA : 20, oA:2,  d : 225,  fa : 0, tm : 1,   v : 1,
					na : "杂兵3", fg: "1", lv:2, rg  : 3, rt : 5, st:4, bH : 100, fH : 50, bA : 50, fA : 25
				},{
					id: 6,  r :  1,  c : 20,  cH : 110, oH : 30, cA : 20, oA:2,  d : 225,  fa : 0, tm : 1,   v : 1,
					na : "杂兵4", fg: "1", lv:2, rg  : 3, rt : 6, st:4, bH : 100, fH : 50, bA : 50, fA : 25
				}],
				
				//脚本中已触发过的事件
				misfiring	: [ "start", "open", "move" ]			 
			};
		}
		
	}
}