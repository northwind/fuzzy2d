package server.impl
{
	public class FakeResponse
	{
		public function FakeResponse()
		{
		}
		
		public static function createMap( req:Object ) : void
		{
			req.rtype = 0;
			req.rvalue = {
				name : "汜水关之战",
				cellXNum : 20,
				cellYNum : 20,
				oX		: 	-50,
				oY		:   -50,
					
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
						d : "train", r: 5, c : 16
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
					}]
			};			
		}
		
		public static function createUnit( req:Object ) : void
		{
			req.rtype = 0;
			req.rvalue = {
				id	 :  1,
				na : "张飞",
				fg   : "zhangfei",			//形象
				lv	 : 1,  					//级别
				
				bH : 100,					//自身属性血量 bodyHP
				fH : 50,					//装备加成    fixHP
					
				bA : 50,
				fA : 25,
				
				sk : [ 1, 2 ],				//技能表
				
				rg  : 6,					//range
				rt  : 2,					//rangeType
				st  : 7					//step				
			};
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
					id: 1,  r :  6,  c : 5,  cH : 110, oH : 30, cA : 20, oA:2,  d : 225,  fa : 0, tm : 1,   v : 1		
				},{
					id: "zb1",  r :  12,  c : 18,  cH : 110, oH : 30, cA : 20, oA:2,  d : 225,  fa : 0, tm : 1,   v : 1,
					na : "杂兵1", fg:"zhangfei", lv:2, rg  : 7, rt : 1, st:4, bH : 100, fH : 50, bA : 50, fA : 25
				}],
				
				//脚本中已触发过的事件
				misfiring	: [ "start", "open", "move" ]			 
			};
		}
		
	}
}