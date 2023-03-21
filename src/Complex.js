
	/**
	 * A class for complex numbers.
	 * @author makc
	 */
	export default class Complex {
		/** Real part. */
		x;

		/** Imaginary part. */
		y;

		/** Principal argument. */
		get arg () {
			return Math.atan2 (this.y, this.x);
		}

		set arg (angle) {
			const _r = this.r; x = _r * Math.cos (angle); y = _r * Math.sin (angle);
		}

		/** Modulus. */
		get r () {
			return Math.sqrt (this.x ** 2 + this.y ** 2);
		}

		set r (length) {
			const scale = length / this.r; this.x *= scale; this.y *= scale;
		}

		/** Returns the conjugate. */
		conj () {
			return Complex.C (this.x, -this.y);
		}

		/** Returns the sum of this number and the argument. */
		add (b) {
			return Complex.C (this.x + b.x, this.y + b.y);
		}

		/** Returns the difference of this number and the argument. */
		sub (b) {
			return Complex.C (this.x - b.x, this.y - b.y);
		}

		/** Returns the product of this number and the argument. */
		mul (b) {
			return Complex.C (this.x * b.x - this.y * b.y, this.y * b.x + this.x * b.y);
		}

		/** Returns the ratio of this number and the argument. */
		div (b) {
			const d = b.x * b.x + b.y * b.y; return Complex.C ((this.x * b.x + this.y * b.y) / d, (this.y * b.x - this.x * b.y) / d);
		}

		/** Returns integer power of this number. */
		ipow (p) {
			const c = Complex.C (1, 0);
			if (p > -1) {
				for (let i = 0; i < p; i++) {
					const _x = this.x * c.x - this.y * c.y;
					const _y = this.y * c.x + this.x * c.y;
					c.x = _x;
					c.y = _y;
				}
				return c;
			}
			return c.div (this).ipow (-p);
		}

		/** Returns exponential function value for this number. */
		exp () {
			const ex = Math.exp (this.x); return Complex.C (ex * Math.cos (this.y), ex * Math.sin (this.y));
		}

		/** Returns the logarithm of this number to base e. */
		ln (k = 0) {
			return Complex.C (Math.log (this.r), this.arg + 2 * Math.PI * k);
		}

		/** Returns complex power of this number. */
		pow (p, k = 0) {
			return p.mul (this.ln (k)).exp ();
		}

		/** Returns the logarithm of this number to complex base. */
		log (b, k = 0, kb = 0) {
			return this.ln (k).div (b.ln (kb));
		}

		/**
		 * Creates permanent instance.
		 * @param	x Real part.
		 * @param	y Imaginary part.
		 */
		constructor (x = 0, y = 0) {
			this.x = x;
			this.y = y;
		}

		static #pool = [];
		static #index = 0;

		/**
		 * Returns temporary instance.
		 * You could use it for a constant until ReleaseTemporaries is called.
		 * @param	x Real part.
		 * @param	y Imaginary part.
		 */
		static C (x = 0, y = 0) {
			if (Complex.#index === Complex.#pool.length) Complex.#pool [Complex.#index] = new Complex;
			const c = Complex.#pool [Complex.#index++]; c.x = x; c.y = y; return c;
		}

		/**
		 * Returns all temporary instances back to the pool.
		 */
		static ReleaseTemporaries () {
			Complex.#index = 0;
		}

		/**
		 * Makes this instsance a copy of given number.
		 * @param	from Input instance to copy.
		 * @return This instance, modified.
		 */
		copy (from) {
			this.x = from.x; this.y = from.y; return this;
		}

		/**
		 * Saves calculation result (or makes a copy of this number).
		 * @param	result Output instance; will be created if not provided.
		 * @param	releaseTemporaries Returns all temporary instances back to the pool.
		 * @return Output instance.
		 */
		save (result = null, releaseTemporaries = false) {
			result = result || new Complex;
			result.copy (this);
			if (releaseTemporaries) Complex.ReleaseTemporaries ();
			return result;
		}

		/**
		 * Returns string representation of this number.
		 * @param	p Required precision.
		 */
		toString (p = 4) {
			return this.x.toPrecision (p) + " " + ((this.y > 0) ? "+" : "") + this.y.toPrecision (p) + "i";
		}
	}