
# 4 bit FPGA - Documentation

---

Immagine a gigantic array of breadboards. Each breadboard has a selection of digital circuit chips like XOR, AND and NOT gates plugged in, all waiting to be connected.
Whatever digital function we can come up with, we can map to those basic gates. And we can then use our bag of jumper cables to connect everything the way we need it to be.
That is an FPGA.
Except that the logic functions are look up tables (LUT) and the cables are the interconnect.
To make the timing of the signals deterministic, registers (D-type flip flops) are added to make it a clocked system.
That is all you need to build an FPGA: LUTs, interconnect and registers.

However, modern FPGA chips have many more features built in to implement frequently used digital operations more easily.
This ranges from the carry chain addon to LUTs, multiply-accumulate blocks (DSP slice) all the way to fully realized CPUs, AI cores and high-speed serial transceivers.

The first step in designing an FPGA is to have a sense of what applications might be realized on it.
It may require a CPU to do networking and graphical user interfaces or be targeted at radio frequency signal acquisition, processing and generation.
For this tiny FPGA project, a few applications should be able to run on it including:

- 4 bit or 8 bit counter
- 4 bit addition
- clock domain crossing

Nevertheless, the architecture shall remain modular to expand it with more features later on.
The initial architecture consists of:

- Configurable Logic Block (including the LUT)
- Interconnect blocks
