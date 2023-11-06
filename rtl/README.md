
## Instructions 
1. Change Directory in terminal to rtl
2. To run the f1 program copy the contents of `test/f1.mem` into `rtl/Instr.mem` (please include the empty line at the end) and type this command into the terminal `source ./f1.sh`
3. To run the reference program copy the contents of `test/ref.mem` into `rtl/Instr.mem` and run the command `source ./ref.sh`, the data memory will load sine.mem

** if `source ./xxx.sh` command is not working copy and paste the contents of the shell files into the terminal

## Versions
There are 3 versions of the CPU. The single-cycle version of the CPU can be found on the `single-cycle` branch and the piplined version can be found on the `damani` branch. The complete version with cache and pipelining can be found on the `main`.

## File Credits
These list who contributed to which modules of the CPU in the Pipelined CPU

|                | Damani | Emre | Indira | Pierce |
|----------------|--------|------|--------|--------|
| ALU.sv         | x      |      | *      |        |
| Cache.sv       |        | *    |        |        |
| ControlUnit.sv | x      | x    | x      | *      |
| CPU.sv         | x      | x    | x      | x      |
| DataMem.sv     |        | x    | *      |        |
| Decode.sv      | *      |      |        |        |
| Execute.sv     | *      |      |        |        |
| Extend.sv      |        | x    |        | *      |
| Fetch.sv       | *      |      |        |        |
| HazardUnit.sv  | *      |      |        |        |
| InstrMem.sv    |        | *    |        |        |
| Memory.sv      | *      |      |        |        |
| MUXN.sv        | *      |      |        |        |
| PC.sv          |        | *    |        |        |
| RegFile.sv     |        |      |        | *      |
| ref_tb.cpp     |        |      | *      |        |
| f1_tb.cpp      |        |      | *      |        | 

 
`* Primary Contributor`

`x Secondary Contributor`
