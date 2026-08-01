`timescale 1ns/1ps

module tb;

    cpu_sc DUT();

    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("task3_tb2.vcd");

        $dumpvars(0, DUT);
    end

    initial begin

        // Optional NOP at 0
        DUT.IMEM.b0[0]=8'h13; DUT.IMEM.b1[0]=8'h00; DUT.IMEM.b2[0]=8'h00; DUT.IMEM.b3[0]=8'h00;

        // -------- Program 2 (start at 1) --------

        // addi x1, x0, 10
        DUT.IMEM.b0[1]=8'h93; DUT.IMEM.b1[1]=8'h00; DUT.IMEM.b2[1]=8'hA0; DUT.IMEM.b3[1]=8'h00;

        // addi x2, x0, 5
        DUT.IMEM.b0[2]=8'h13; DUT.IMEM.b1[2]=8'h01; DUT.IMEM.b2[2]=8'h50; DUT.IMEM.b3[2]=8'h00;

        // add x3, x1, x2
        DUT.IMEM.b0[3]=8'hB3; DUT.IMEM.b1[3]=8'h81; DUT.IMEM.b2[3]=8'h20; DUT.IMEM.b3[3]=8'h00;

        // sub x4, x3, x2
        DUT.IMEM.b0[4]=8'h33; DUT.IMEM.b1[4]=8'h02; DUT.IMEM.b2[4]=8'h32; DUT.IMEM.b3[4]=8'h40;

        // lw x5, 0(x3)
        DUT.IMEM.b0[5]=8'h83; DUT.IMEM.b1[5]=8'h22; DUT.IMEM.b2[5]=8'h00; DUT.IMEM.b3[5]=8'h00;

        // add x6, x5, x1
        DUT.IMEM.b0[6]=8'h33; DUT.IMEM.b1[6]=8'h03; DUT.IMEM.b2[6]=8'h51; DUT.IMEM.b3[6]=8'h00;

        // sw x6, 0(x2)
        DUT.IMEM.b0[7]=8'h23; DUT.IMEM.b1[7]=8'h20; DUT.IMEM.b2[7]=8'h63; DUT.IMEM.b3[7]=8'h00;

        #1000;
        $finish;
    end

endmodule