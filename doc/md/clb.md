# Configurable Logic Block (CLB)

---

A look up table has to have at least 2 inputs and one output.
To create more useful functions, more inputs are added.
One could create a LUT with 16 inputs to cover logic operations that depend on up to 16 input variables.
Such functions are rare and many of the inputs (and subsequently area on the silicon) would be wasted.
There is a balance regarding the maximum number of inputs which is somewhere between 4 and 6 inputs.
Various FPGA vendors have different approaches to it.

## Number of Inputs / Outputs

The number of outputs is usually 1. Some vendors however allow a 6:1 LUT to be configured as a 5:2 LUT instead, offering 2 outputs taking the same 5 signals as inputs.
This FPGA does not have a configurable number of outputs.
It would increase the complexity of the output routing and interconnect.



## CLB Architecture

![img/clb-arch.png](img/clb-arch.png)


### Carry Chain

Multiple LUTs are usually bundeled within a block that is then called a configurable logic block (CLB).
(Sometimes LUTs are bundeled in slices and slices are bundeled in a block)
The CLB adds additional features and configurable options between the LUTs inside that block.
The most common feature is the carry chain.
One feature that is added to this FPGA is the carry chain.

### Connection Ports

The CLB requires input ports and output ports. 
A helpful simplification in the overall FPGA architecture is to define a direction in which the signals travel.
In this FPGA it is from west to east and in a weaker sense from north to south.

The CLB has four bus input ports:
- 4 bit bus north
	+ this is one of the 4 bit inputs for the adder mode
- 4 bit bus south
	+ this is one of the 4 bit inputs for the adder mode
- 4 bit bus west
	+ this bus is the direct output of the west CLB
- 4 bit preselected input
	+ each bit is preselected to any one signal of the bus
	+ allows for bit position changes (shift / rotate / flip)

The CLB has one 4 bit output port.

The CLB has 2 carry in signals and one carry out signal.
- North `cin` 
	+ can be activated in the north connection box
- South `cin` 
	+ can be activated in the north connection box of the south CLB

### Input Multiplexers 4:1 (post select) `insel*`




