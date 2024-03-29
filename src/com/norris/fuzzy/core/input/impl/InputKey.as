package com.norris.fuzzy.core.input.impl
{
	import flash.ui.Keyboard;
	
	public class InputKey 
	{
		public static const INVALID:uint = 0;
		
		public static const BACKSPACE:uint = 8;
		public static const TAB:uint = 9;
		public static const ENTER:uint = 13;
		public static const COMMAND:uint = 15;
		public static const SHIFT:uint = 16;
		public static const CONTROL:uint = 17;
		public static const ALT:uint = 18;
		public static const PAUSE:uint = 19;
		public static const CAPS_LOCK:uint = 20;
		public static const ESCAPE:uint = 27;
		
		public static const SPACE:uint = 32;
		public static const PAGE_UP:uint = 33;
		public static const PAGE_DOWN:uint = 34;
		public static const END:uint = 35;
		public static const HOME:uint = 36;
		public static const LEFT:uint = 37;
		public static const UP:uint = 38;
		public static const RIGHT:uint = 39;
		public static const DOWN:uint = 40;
		
		public static const INSERT:uint = 45;
		public static const DELETE:uint = 46;
		
		public static const ZERO:uint = 48;
		public static const ONE:uint = 49;
		public static const TWO:uint = 50;
		public static const THREE:uint = 51;
		public static const FOUR:uint = 52;
		public static const FIVE:uint = 53;
		public static const SIX:uint = 54;
		public static const SEVEN:uint = 55;
		public static const EIGHT:uint = 56;
		public static const NINE:uint = 57;
		
		public static const A:uint = 65;
		public static const B:uint = 66;
		public static const C:uint = 67;
		public static const D:uint = 68;
		public static const E:uint = 69;
		public static const F:uint = 70;
		public static const G:uint = 71;
		public static const H:uint = 72;
		public static const I:uint = 73;
		public static const J:uint = 74;
		public static const K:uint = 75;
		public static const L:uint = 76;
		public static const M:uint = 77;
		public static const N:uint = 78;
		public static const O:uint = 79;
		public static const P:uint = 80;
		public static const Q:uint = 81;
		public static const R:uint = 82;
		public static const S:uint = 83;
		public static const T:uint = 84;
		public static const U:uint = 85;
		public static const V:uint = 86;
		public static const W:uint = 87;
		public static const X:uint = 88;
		public static const Y:uint = 89;
		public static const Z:uint = 90;
		
		public static const NUM0:uint = 96;
		public static const NUM1:uint = 97;
		public static const NUM2:uint = 98;
		public static const NUM3:uint = 99;
		public static const NUM4:uint = 100;
		public static const NUM5:uint = 101;
		public static const NUM6:uint = 102;
		public static const NUM7:uint = 103;
		public static const NUM8:uint = 104;
		public static const NUM9:uint = 105;
		
		public static const MULTIPLY:uint = 106;
		public static const ADD:uint = 107;
		public static const NUMENTER:uint = 108;
		public static const SUBTRACT:uint = 109;
		public static const DECIMAL:uint = 110;
		public static const DIVIDE:uint = 111;
		
		public static const F1:uint = 112;
		public static const F2:uint = 113;
		public static const F3:uint = 114;
		public static const F4:uint = 115;
		//public static const F5:uint = 116;
		public static const F6:uint = 117;
		public static const F7:uint = 118;
		public static const F8:uint = 119;
		public static const F9:uint = 120;
		// F10 is considered 'reserved' by Flash
		public static const F10:uint = 121;
		public static const F11:uint = 122;
		public static const F12:uint = 123;
		
		public static const NUM_LOCK:uint = 144;
		public static const SCROLL_LOCK:uint = 145;
		
		public static const COLON:uint = 186;
		public static const PLUS:uint = 187;
		public static const COMMA:uint = 188;
		public static const MINUS:uint = 189;
		public static const PERIOD:uint = 190;
		public static const BACKSLASH:uint = 191;
		public static const TILDE:uint = 192;
		
		public static const LEFT_BRACKET:uint = 219;
		public static const SLASH:uint = 220;
		public static const RIGHT_BRACKET:uint = 221;
		public static const QUOTE:uint = 222;
		
		//public static const MOUSE_BUTTON:uint = 253;
		public static const MOUSE_LEFT:uint = 254;
		public static const MOUSE_RIGHT:uint = 255;
		public static const MOUSE_WHEEL:uint = 256;
		public static const MOUSE_MOVE:uint = 257;
		public static const MOUSE_OVER:uint = 258;
		public static const MOUSE_OUT:uint = 259;
		public static const MOUSE_UP:uint = 260;
		public static const CLICK:uint = 261;
		
		public static const ANYKEY:uint = 500;
		
		public function InputKey()
		{
		}
		
	}
}