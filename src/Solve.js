import Complex from "./Complex"; export { Complex };

const A = new Complex;
const B = new Complex;
const C = new Complex;
const D = new Complex;

const p = new Complex;
const q = new Complex;
const r = new Complex;
const s = new Complex;

const P = new Complex;
const Q = new Complex;
const R = new Complex;
const S = new Complex;

/** z⁴ + Az³ + Bz² + Cz + D = 0 */
function f ( z ) {
    return ( z.ipow (4) )
      .add ( z.ipow (3).mul (A) )
      .add ( z.ipow (2).mul (B) )
      .add ( z.mul (C) )
      .add ( D );
}

function safeDiv ( a, b ) {
    const c = a.div ( b );
    if( isNaN (c.x) ) {
        c.x = Math.random () - Math.random ();
        c.y = Math.random () - Math.random ();
    }
    return c;
}

/**
 * Solves 4th power polynomials using Durand-Kerner method.
 * @see https://en.wikipedia.org/wiki/Durand-Kerner_method#Explanation
 */
export function solve4 (a, b, c, d, releaseTemporaries = true) {
    // accept duck-typed arguments
    A.copy (a); B.copy (b); C.copy (c); D.copy (d);

    const seed = Complex.C (0.4, 0.9);

    seed.ipow (0).save (p);
    seed.ipow (1).save (q);
    seed.ipow (2).save (r);
    seed.ipow (3).save (s);

    while (true) {
        // P = p-f(p)/((p-q)(p-r)(p-s))
        p.sub (
            safeDiv (f (p),
                ( p.sub (q) ).mul( p.sub (r) ).mul( p.sub (s) )
            )
        ).save (P);

        // Q = q-f(q)/((q-p)(q-r)(q-s))
        q.sub (
            safeDiv (f (q),
                ( q.sub (p) ).mul( q.sub (r) ).mul( q.sub (s) )
            )
        ).save (Q);

        // R = r-f(r)/((r-p)(r-q)(r-s))
        r.sub (
            safeDiv (f (r),
                ( r.sub (p) ).mul( r.sub (q) ).mul( r.sub (s) )
            )
        ).save (R);

        // S = s-f(s)/((s-p)(s-q)(s-r))
        s.sub (
            safeDiv (f (s),
                ( s.sub (p) ).mul( s.sub (q) ).mul( s.sub (r) )
            )
        ).save (S);

        if (p.sub (P).r + q.sub (Q).r + r.sub (R).r + s.sub (S).r < 1e-8) {
            // converged
            break;
        } else {
            // on to next iteration
            P.save (p); Q.save (q); R.save (r); S.save (s, releaseTemporaries);
        }
    }

    if (releaseTemporaries) {
        // we no longer need temporary variables - return them all to the pool
        Complex.ReleaseTemporaries ();
    }

    return [P, Q, R, S];
}