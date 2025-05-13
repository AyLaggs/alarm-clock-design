# Alarm Clock Design in SystemVerilog

•	Programmed 7-segment hex displays on DE0-CV board using 4:7 decoder (SystemVerilog, FPGA).
•	Engineered a mod 1001 counter that outputs in decimal on two hex displays (SystemVerilog, FPGA).
•	Assembled an alarm clock and a 24-hour clock with precise clock-frequency tuning, switch functions, 
and reuse of previously built modules (Digital Logic, SystemVerilog, FPGA).

## File Structure

- `src/`: Source design files
- `output_files/`: Output files
- `sim/`: Simulation logs
- `docs/`: Project documentation

## MAIN FILES

- 'lab3.sv' is the main alarm clock design file
- 'dflip.sv' contains the D Flip-Flop
- 'lab_counter.sv' is the n-bit loop counter
- 'lab1_b.sv' is the HEX display decoder
