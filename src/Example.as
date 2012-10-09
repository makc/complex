/*
 * Solving user-defined 4th power polynomials as an example.
 */
package {
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.ideaskill.math.Complex;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	[SWF (width=465, height=465)]
	public class Example extends Sprite {
		private var A:Complex = new Complex;
		private var B:Complex = new Complex;
		private var C:Complex = new Complex;
		private var D:Complex = new Complex;
		private function f (z:Complex):Complex {
			return ( z.ipow (4) )
			  .add ( z.ipow (3).mul (A) )
			  .add ( z.ipow (2).mul (B) )
			  .add ( z.mul (C) )
			  .add ( D );
		}

		private var p:Complex = new Complex;
		private var q:Complex = new Complex;
		private var r:Complex = new Complex;
		private var s:Complex = new Complex;
		private var P:Complex = new Complex;
		private var Q:Complex = new Complex;
		private var R:Complex = new Complex;
		private var S:Complex = new Complex;
		private var v:Vector.<Number> = new Vector.<Number>;

		/**
		 * Solves 4th power polynomials using Durand-Kerner method.
		 * @see http://en.wikipedia.org/wiki/Durand-Kerner_method#Explanation
		 */
		public function solve (e:Event):void {
			v.length = 0;

			A.x = parseFloat (inpA.text);
			B.x = parseFloat (inpB.text);
			C.x = parseFloat (inpC.text);
			D.x = parseFloat (inpD.text);

			// an example of using temporary instance without memory
			// allocation (unless the pool is still empty)
			var seed:Complex = Complex.C (0.4, 0.9);

			seed.ipow (0).save (p);
			seed.ipow (1).save (q);
			seed.ipow (2).save (r);
			seed.ipow (3).save (s);

			var N:int = 0;
			while (true) {
				v.push (p.x, p.y, q.x, q.y, r.x, r.y, s.x, s.y);

				// P = p-f(p)/((p-q)(p-r)(p-s))
				p.sub (
					f (p).div (
						( p.sub (q) ).mul( p.sub (r) ).mul( p.sub (s) )
					)
				).save (P);

				// Q = q-f(q)/((q-p)(q-r)(q-s))
				q.sub (
					f (q).div (
						( q.sub (p) ).mul( q.sub (r) ).mul( q.sub (s) )
					)
				).save (Q);

				// R = r-f(r)/((r-p)(r-q)(r-s))
				r.sub (
					f (r).div (
						( r.sub (p) ).mul( r.sub (q) ).mul( r.sub (s) )
					)
				).save (R);

				// S = s-f(s)/((s-p)(s-q)(s-r))
				s.sub (
					f (s).div (
						( s.sub (p) ).mul( s.sub (q) ).mul( s.sub (r) )
					)
				).save (S);

				if (p.sub (P).r + q.sub (Q).r + r.sub (R).r + s.sub (S).r < 1e-8) {
					// converged
					break;
				} else {
					// on to next iteration
					P.save (p); Q.save (q); R.save (r); S.save (s); N++;
				}
			}

			// now when we no longer need temporary variables - return them all to the pool
			Complex.ReleaseTemporaries ();

			showResults (N);
		}

		public function solveRandom (e:Event):void {
			inpA.text = Math.random ().toPrecision (4);
			inpB.text = Math.random ().toPrecision (4);
			inpC.text = Math.random ().toPrecision (4);
			inpD.text = Math.random ().toPrecision (4);

			solve (e);
		}

		private var inpA:InputText;
		private var inpB:InputText;
		private var inpC:InputText;
		private var inpD:InputText;
		private var out:TextField;

		public function Example () {
			var l1:Label = new Label (this, 30, 20, "z^4 + ");
			inpA = new InputText (this, l1.x + l1.width, 20, "0.2974");
			inpA.width = 40;
			var l2:Label = new Label (this, inpA.x + inpA.width, 20, "z^3 + ");
			inpB = new InputText (this, l2.x + l2.width, 20, "0.5916");
			inpB.width = 40;
			var l3:Label = new Label (this, inpB.x + inpB.width, 20, "z^2 + ");
			inpC = new InputText (this, l3.x + l3.width, 20, "0.1393");
			inpC.width = 40;
			var l4:Label = new Label (this, inpC.x + inpC.width, 20, "z + ");
			inpD = new InputText (this, l4.x + l4.width, 20, "0.0101");
			inpD.width = 40;
			var l5:Label = new Label (this, inpD.x + inpD.width, 20, " = 0");

			new PushButton (this, inpA.x, 60, "solve", solve);
			new PushButton (this, inpA.x + 120, 60, "randomize & solve", solveRandom);

			with (addChild (out = new TextField)) { autoSize = "left"; y = 100; }
			out.defaultTextFormat = l1.textField.getTextFormat ();
			out.embedFonts = true; out.x = inpA.x;

			solve (null);

			// unrelated quick tests
			trace (Complex.C (Math.E).ln ().save (null, true), "= 1");
			trace (Complex.C (0, 2).ipow (2).save (null, true), "= -4");
			trace (Complex.C (1).add (Complex.C (1e-4)).pow (Complex.C (1e4)).log (Complex.C (Math.E)).save (null, true), "~ 1");
			trace (Complex.C (0, 2).ipow ( -2).save (null, true), "= -.25");
			trace (Complex.C (0, 2 * Math.PI).exp ().save (null, true), "= 1");
		}

		private function showResults (N:int):void {
			out.htmlText = N + " iterations, roots:\n\n " + P + ",\n " + Q + ",\n " + R + ",\n " + S +
				"\n\n<a href=\"http://www.wolframalpha.com/input/?i=" + encodeURIComponent ("z^4 + " +
					A.x.toPrecision (4) + " z^3 + " +
					B.x.toPrecision (4) + " z^2 + " +
					C.x.toPrecision (4) + " z + " +
					D.x.toPrecision (4) + " = 0") +
				"\"><font color=\"#0000FF\">verify at WolframAlpha</font></a>";
		
			graphics.clear ();
			graphics.lineStyle (2, 0);
			graphics.moveTo (465 / 2, 0); graphics.lineTo (465 / 2, 465);
			graphics.moveTo (0, 465 / 2); graphics.lineTo (465, 465 / 2);
			graphics.lineStyle (1, 0);
			graphics.moveTo (465 / 4, 0); graphics.lineTo (465 / 4, 465);
			graphics.moveTo (0, 465 / 4); graphics.lineTo (465, 465 / 4);
			graphics.moveTo (3 * 465 / 4, 0); graphics.lineTo (3 * 465 / 4, 465);
			graphics.moveTo (0, 3 * 465 / 4); graphics.lineTo (465, 3 * 465 / 4);
			graphics.drawCircle (
				465 / 2 + 465 / 4 * P.x,
				465 / 2 - 465 / 4 * P.y,
				2);
			graphics.drawCircle (
				465 / 2 + 465 / 4 * Q.x,
				465 / 2 - 465 / 4 * Q.y,
				2);
			graphics.drawCircle (
				465 / 2 + 465 / 4 * R.x,
				465 / 2 - 465 / 4 * R.y,
				2);
			graphics.drawCircle (
				465 / 2 + 465 / 4 * S.x,
				465 / 2 - 465 / 4 * S.y,
				2);
			for (var i:int = 1; i < v.length / 8; i++) {
				for (var j:int = 0; j < 4; j++) {
					var x0:Number = v [8 * (i - 1) + 2 * j];
					var y0:Number = v [8 * (i - 1) + 2 * j + 1];
					var x1:Number = v [8 * i + 2 * j];
					var y1:Number = v [8 * i + 2 * j + 1];
					arrow (
						465 / 2 + 465 / 4 * x0, 465 / 2 - 465 / 4 * y0,
						465 / 2 + 465 / 4 * x1, 465 / 2 - 465 / 4 * y1,
						255 * (((j + 1) & 1) + 256 * ((((j + 1) >> 1) & 1) + 256 * (((j + 1) >> 2) & 1)))
					);					
				}
			}
		}

		private function arrow (x0:Number, y0:Number, x1:Number, y1:Number, c:uint):void {
			var idx:Number = .1 * (x1 - x0);
			var idy:Number = .1 * (y1 - y0);
			graphics.lineStyle (0, c);
			graphics.moveTo (x0, y0);
			graphics.lineTo (x1, y1);
			graphics.lineTo (x1 - 2 * idx - idy, y1 - 2 * idy + idx);
			graphics.moveTo (x1, y1);
			graphics.lineTo (x1 - 2 * idx + idy, y1 - 2 * idy - idx);
		}
	}
}