`timescale 1ns/1ps

module tb;

    cpu_sc DUT();

    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("task3_tb3.vcd");

        $dumpvars(0, DUT);
    end

    initial begin

        // Optional NOP
        DUT.IMEM.b0[0]=8'h13; DUT.IMEM.b1[0]=8'h00; DUT.IMEM.b2[0]=8'h00; DUT.IMEM.b3[0]=8'h00;

        // -------- Program 3 (start at 1) --------

        // addi x1, x0, 0
        DUT.IMEM.b0[1]=8'h93; DUT.IMEM.b1[1]=8'h00; DUT.IMEM.b2[1]=8'h00; DUT.IMEM.b3[1]=8'h00;

        // addi x2, x0, 1
        DUT.IMEM.b0[2]=8'h13; DUT.IMEM.b1[2]=8'h01; DUT.IMEM.b2[2]=8'h10; DUT.IMEM.b3[2]=8'h00;

        // addi x3, x0, 10
        DUT.IMEM.b0[3]=8'h93; DUT.IMEM.b1[3]=8'h01; DUT.IMEM.b2[3]=8'hA0; DUT.IMEM.b3[3]=8'h00;

        // loop:
        // add x4, x1, x2
        DUT.IMEM.b0[4]=8'h33; DUT.IMEM.b1[4]=8'h02; DUT.IMEM.b2[4]=8'h11; DUT.IMEM.b3[4]=8'h00;

        // add x1, x2, x0
        DUT.IMEM.b0[5]=8'hB3; DUT.IMEM.b1[5]=8'h00; DUT.IMEM.b2[5]=8'h21; DUT.IMEM.b3[5]=8'h00;

        // add x2, x4, x0
        DUT.IMEM.b0[6]=8'h33; DUT.IMEM.b1[6]=8'h01; DUT.IMEM.b2[6]=8'h42; DUT.IMEM.b3[6]=8'h00;

        // addi x3, x3, -1
        DUT.IMEM.b0[7]=8'h93; DUT.IMEM.b1[7]=8'h81; DUT.IMEM.b2[7]=8'hF1; DUT.IMEM.b3[7]=8'hFF;

        // bne x3, x0, loop  (offset = -4 instructions)
        DUT.IMEM.b0[8]=8'hE3; DUT.IMEM.b1[8]=8'h1C; DUT.IMEM.b2[8]=8'h01; DUT.IMEM.b3[8]=8'hFE;

        #3000;   // longer run (loop)
        $finish;
    end

endmodule