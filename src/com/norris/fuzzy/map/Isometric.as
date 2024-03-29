﻿package com.norris.fuzzy.map {
	import com.norris.fuzzy.map.geom.Coordinate;
	
	/**
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public class Isometric {
		
		//trigonometric values stored for later use
		private var _sinTheta:Number;
		private var _cosTheta:Number;
		private var _sinAlpha:Number;
		private var _cosAlpha:Number;
		
		/**
		 * Isometric class contrustor.
		 * @param	declination value. Defaults to the most common value, which is 30.
		 */
		public function Isometric( theta:Number = 30, alpha:Number = 45 ) {
			theta *= Math.PI/180;
			alpha *= Math.PI/180;
			_sinTheta = Math.sin(theta);
			_cosTheta = Math.cos(theta);
			_sinAlpha = Math.sin(alpha);
			_cosAlpha = Math.cos(alpha);
		}
		
		/**
		 * Maps 3D coordinates to the 2D screen
		 * @param	x coordinate
		 * @param	y coordinate
		 * @param	z coordinate
		 * @return	Coordinate instance containig screen x and screen y
		 */
		public function mapToScreen(xpp:Number, ypp:Number, zpp:Number):Coordinate {
			return new Coordinate(xpp*_cosAlpha+zpp*_sinAlpha, ypp*_cosTheta-(zpp*_cosAlpha-xpp*_sinAlpha)*_sinTheta, 0);
		}
		
		/**
		 * Maps 2D screen coordinates into 3D coordinates. It is assumed that the target 3D y coordinate is 0.
		 * @param	screen x coordinate
		 * @param	screen y coordinate
		 * @return	Coordinate instance containig 3D x, y, and z
		 */
		public function mapToIsoWorld(screenX:Number, screenY:Number):Coordinate {
			var z:Number = (screenX/_cosAlpha-screenY/(_sinAlpha*_sinTheta))*(1/(_cosAlpha/_sinAlpha+_sinAlpha/_cosAlpha));
			return new Coordinate((1/_cosAlpha)*(screenX-z*_sinAlpha), 0, z);
		}
		
	}
}