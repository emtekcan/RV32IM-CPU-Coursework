rm -rf obj_dir
rm -f CPU.vcd

verilator -cc -trace CPU.sv --exe ref_tb.cpp

make -j -C obj_dir/ -f VCPU.mk VCPU

obj_dir/VCPU
