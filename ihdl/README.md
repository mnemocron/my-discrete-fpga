# iHDL Language Specification

---

## General Rules

### Assignments

#### Static Assignment `:=`

`<var> := <const>;`

Assigning location properties or other static features that can be enabled or disabled.

Example, location constraint:
> `loc := "A1";`

#### Synchronous Assignment `<=`

`<port> <= <expr>;`

Synchronous assignment of a boolean function of input ports to an output port.
Using the synchronous assignment will evoque a D-type flip flop in the output signal to the specified port.

Example,
> `q0 <= b0 and b1;`

#### Asynchronous Assignment `

`<port> = <expr>;`

Asynchronous assignment of a boolean function of input ports to an output port.
Using the asynchronous assignment will output the evaluated signal directly to the specified port without a register stage.

Example,
> `q0 = b0 and b1;`

---

## Objects

The following objects can be instantiated.

### CLB Slice `slice`

#### Input Ports

- bus inputs (north) `b0`,`b1`,`b2`,`b3`
- sum inputs (north) `n0`,`n1`,`n2`,`n3`
- sum inputs (south) `s0`,`s1`,`s2`,`s3`
- lut expansion inputs `x0`,`x1`,`x2`,`x3`
- highway inputs (north) `h0`,`h1`

#### Output Ports

- bus outputs (east) `b0`,`b1`,`b2`,`b3`
- highway outputs (east) 

#### Internal signals

The following signals are optional to be assigned to the highway signals `h0` and `h1` when using the slice in the adder mode.

- sum carry input `cin`
- sum carry output `cout`

#### Options

- location constraint `loc`
- 

#### Operators

Valid operators are
- `and`
- `or`
- `not`
- `xor`
- `+` (arithmetical sum)

Valid values besides inputs are 
- `0` zero / GND
- `1` one / Vcc


## Error Types







