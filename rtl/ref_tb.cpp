#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VCPU.h"
#include"vbuddy.cpp"

#define CYCLES 800000
#define RF_WIDTH 8
#define ROM_SIZE 256
int main(int argc, char **argv, char **ldv){
    int i;
    int clk;

    Verilated::commandArgs(argc,argv);
    VCPU* top= new VCPU;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    top->trace (tfp, 99);
    tfp->open("CPU.vcd");

    if(vbdOpen()!=1) return(-1);
    vbdHeader("Cache: REF");

    top->clk = 1;
    top->rst = 0;

    for (i = 0; i<CYCLES; i++) {
        for (clk = 0; clk < 2; clk++){
            tfp->dump (2*i+clk);
            top->clk = !top->clk;
            top->eval();
        }

        if(i>600000)
        {vbdPlot(int(top->a0),0,255);}
        if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
            exit(0);    
    }
    vbdClose();
  printf("Exiting\n");
  exit(0);

    
}