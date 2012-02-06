package com.ideaskill.math {
	/**
	 * A class for complex numbers.
	 * @author makc
	 */
	public class Complex {
		/** Real part. */
		public var x:Number;

		/** Imaginary part. */
		public var y:Number;

		/** Principal argument. */
		public function get arg ():Number {
			return Math.atan2 (y, x);
		}

		public function set arg (angle:Number):void {
			var _r:Number = r; x = _r * Math.cos (angle); y = _r * Math.sin (angle);
		}

		/** Modulus. */
		public function get r ():Number {
			return Math.sqrt (x * x + y * y);
		}

		public function set r (length:Number):void {
			var scale:Number = length / r; x *= scale; y *= scale;
		}

		/** Returns the conjugate. */
		public function conj ():Complex {
			return C (x, -y);
		}

		/** Returns the sum of this number and the argument. */
		public function add (b:Complex):Complex {
			return C (x + b.x, y + b.y);
		}

		/** Returns the difference of this number and the argument. */
		public function sub (b:Complex):Complex {
			return C (x - b.x, y - b.y);
		}

		/** Returns the product of this number and the argument. */
		public function mul (b:Complex):Complex {
			return C (x * b.x - y * b.y, y * b.x + x * b.y);
		}

		/** Returns the ratio of this number and the argument. */
		public function div (b:Complex):Complex {
			var d:Number = b.x * b.x + b.y * b.y; return C ((x * b.x + y * b.y) / d, (y * b.x - x * b.y) / d);
		}

		/** Returns integer power of this number. */
		public function ipow (p:int):Complex {
			var c:Complex = C (1, 0);
			if (p > -1) {
				for (var i:int = 0; i < p; i++) {
					var _x:Number = x * c.x - y * c.y;
					var _y:Number = y * c.x + x * c.y;
					c.x = _x;
					c.y = _y;
				}
				return c;
			}
			return c.div (this).ipow (-p);
		}

		/** Returns exponential function value for this number. */
		public function exp ():Complex {
			var ex:Number = Math.exp (x); return C (ex * Math.cos (y), ex * Math.sin (y));
		}

		/** Returns the logarithm of this number to base e. */
		public function ln (k:int = 0):Complex {
			return C (Math.log (r), arg + 2 * Math.PI * k);
		}

		/** Returns complex power of this number. */
		public function pow (p:Complex, k:int = 0):Complex {
			return p.mul (ln (k)).exp ();
		}

		/** Returns the logarithm of this number to complex base. */
		public function log (b:Complex, k:int = 0, kb:int = 0):Complex {
			return ln (k).div (b.ln (kb));
		}

		/**
		 * Creates permanent instance.
		 * @param	x Real par.
		 * @param	y Imaginary part.
		 */
		public function Complex (x:Number = 0, y:Number = 0) {
			this.x = x;
			this.y = y;
		}

		private static var pool:Vector.<Complex> = new Vector.<Complex>;
		private static var index:int = 0;

		/**
		 * Returns temporary instance.
		 * You could use it for a constant in one calculation.
		 * @param	x Real par.
		 * @param	y Imaginary part.
		 */
		public static function C (x:Number = 0, y:Number = 0):Complex {
			if (index == pool.length) pool [index] = new Complex;
			var c:Complex = pool [index++]; c.x = x; c.y = y; return c;
		}

		/**
		 * Saves calculation result (or makes a copy of this number).
		 * @param	result Output instance; will be created if not provided.
		 * @param	releaseTemporaries Returns all temporary instances back to the pool.
		 * @return Output instance.
		 */
		public function save (result:Complex = null, releaseTemporaries:Boolean = true):Complex {
			if (result == null) result = new Complex;
			result.x = x; result.y = y; if (releaseTemporaries) index = 0; return result;
		}

		/**
		 * Returns string representation of this number.
		 * @param	p Required precision.
		 */
		public function toString (p:uint = 4):String {
			return x.toPrecision (p) + " " + ((y > 0) ? "+" : "") + y.toPrecision (p) + "i";
		}
	}
}