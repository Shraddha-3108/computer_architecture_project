`timescale 1ns/1ps

module tb;

    cpu_sc DUT();

    string vcd_file;

    // VCD dump setup
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("task3_tb1.vcd");

        $dumpvars(0, DUT);
    end

    initial begin

        // -------- Program 1 (starting at IMEM[1]) --------

        DUT.IMEM.b0[1]=8'h93; DUT.IMEM.b1[1]=8'h00; DUT.IMEM.b2[1]=8'hA0; DUT.IMEM.b3[1]=8'h00;
        DUT.IMEM.b0[2]=8'h13; DUT.IMEM.b1[2]=8'h01; DUT.IMEM.b2[2]=8'h40; DUT.IMEM.b3[2]=8'h01;
        DUT.IMEM.b0[3]=8'h13; DUT.IMEM.b1[3]=8'h02; DUT.IMEM.b2[3]=8'h50; DUT.IMEM.b3[3]=8'h00;
        DUT.IMEM.b0[4]=8'h93; DUT.IMEM.b1[4]=8'hC1; DUT.IMEM.b2[4]=8'hF0; DUT.IMEM.b3[4]=8'h0F;
        DUT.IMEM.b0[5]=8'h93; DUT.IMEM.b1[5]=8'h81; DUT.IMEM.b2[5]=8'h11; DUT.IMEM.b3[5]=8'h00;
        DUT.IMEM.b0[6]=8'hB3; DUT.IMEM.b1[6]=8'h02; DUT.IMEM.b2[6]=8'h12; DUT.IMEM.b3[6]=8'h40;
        DUT.IMEM.b0[7]=8'h33; DUT.IMEM.b1[7]=8'h03; DUT.IMEM.b2[7]=8'h41; DUT.IMEM.b3[7]=8'h00;
        DUT.IMEM.b0[8]=8'hB3; DUT.IMEM.b1[8]=8'h83; DUT.IMEM.b2[8]=8'h21; DUT.IMEM.b3[8]=8'h00;

        // run simulation
        #1000;

        $finish;
    end

endmodule