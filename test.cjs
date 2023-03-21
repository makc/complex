const { Complex, solve4 } = require('./build/index.cjs'), C = Complex.C;

// just test some basic shit and log it for now

const result = new Complex ();

console.log (C (Math.E).ln ().save (result, true), "= 1");
console.log (C (0, 2).ipow (2).save (result, true), "= -4");
console.log (C (1).add (C (1e-4)).pow (C (1e4)).log (C (Math.E)).save (result, true), "~ 1");
console.log (C (0, 2).ipow ( -2).save (result, true), "= -.25");
console.log (C (0, 2 * Math.PI).exp ().save (result, true), "= 1");

console.log (new Complex (-1).arg, "~ \u03c0");
console.log (new Complex (-1, 1).r - Math.SQRT2, "= 0");

// solve random equation

const a = { x: Math.random(), y: 0 };
const b = { x: Math.random(), y: 0 };
const c = { x: Math.random(), y: 0 };
const d = { x: Math.random(), y: 0 };

const roots = solve4( a, b, c, d );

console.log(
    "\nrandom equation roots:\n\n " + roots[0] + ",\n " + roots[1] + ",\n " + roots[2] + ",\n " + roots[3] +
	"\n\nhttps://www.wolframalpha.com/input/?i=" + encodeURIComponent ("z^4 + " +
            a.x.toPrecision (4) + " z^3 + " +
            b.x.toPrecision (4) + " z^2 + " +
            c.x.toPrecision (4) + " z + " +
            d.x.toPrecision (4) + " = 0"
        )
    );