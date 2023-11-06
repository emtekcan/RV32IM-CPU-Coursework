#include "VCPU.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"
#include <iostream>

int main(int argc, char **argv, char **env)
{
    int cyc;
    int clock;

    Verilated::commandArgs(argc, argv);

    VCPU *top = new VCPU;

    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;

    top->trace(tfp, 99);
    tfp->open("CPU.vcd");
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("Formula 1");
    vbdSetMode(1);

    top->clk = 1;
    top->rst = 0;

    for (cyc = 0; cyc < 10000; cyc++)
    {

        for (clock = 0; clock < 2; clock++)
        {
            tfp->dump(2 * cyc + clock);
            top->clk = !top->clk;
            top->eval();
        }

        top->rst = vbdFlag();
        vbdBar(top->a0 & 0xFF); // activates neopixel strip
        vbdCycle(cyc);

        if (Verilated::gotFinish() || (vbdGetkey()=='q'))
            exit(0);
    }
    vbdClose();
    tfp->close();
    exit(0);
}
