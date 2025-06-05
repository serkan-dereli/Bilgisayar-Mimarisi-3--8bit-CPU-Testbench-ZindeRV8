module ZindeRV8 (
    input clkn, rstn, we_in, sel_in,
    input [7:0] data_in, adr_in,
    output [7:0] data_out, data_mem_in,
    output [7:0] tbDR, tbAC, tbAR, tbPC, tbIR, tbBus,
    output we_out
);
    
    wire we;
    wire [7:0] from_mem, to_mem, adr, cpu_adr, cpu_mem, cpu_we; 
    wire [7:0] testDR, testAC, testAR, testPC, testIR, testBus;
    
    assign data_out=from_mem;
    assign data_mem_in=to_mem;
    assign we_out=we;
    //test amaçlý
    assign tbDR=testDR;
    assign tbAC=testAC;
    assign tbPC=testPC;
    assign tbAR=testAR;
    assign tbIR=testIR;
    assign tbBus=testBus;
    
    //dýþardan ram a program yüklemek için
    //sel_in=1 ise RAM a program yükleniyor
    assign to_mem = (sel_in==1'b1) ? data_in : cpu_mem; 
    assign adr = (sel_in==1'b1) ? adr_in : cpu_adr;
    assign we = (sel_in==1'b1) ? we_in : cpu_we;
    
    zinde_cpu_8bit cpu(
        .clk(clkn), 
        .rst(rstn),
        .sel_in(sel_in),
        .from_memory(from_mem),
        //output
        .to_memory(cpu_mem), 
        .address(cpu_adr),
        .write(cpu_we),
        //test output
        .testDR(testDR), 
        .testAC(testAC), 
        .testAR(testAR), 
        .testPC(testPC),
        .testIR(testIR),
        .testBus(testBus)
    );
    
    ram
    #(
        .DATA_WIDTH(4'h8),
        .ADDR_WIDTH(4'h8)
    )
    ram256byte (
        .clk(clkn),
        .we(we),
        .addr(adr),
        .din(to_mem),
        .dout(from_mem)
    );
    
endmodule
