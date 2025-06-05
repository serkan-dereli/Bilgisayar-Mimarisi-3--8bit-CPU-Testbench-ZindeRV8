//25.05.2025, pazar

module zinde_cpu_8bit(
    input clk, rst, sel_in,
    input [7:0] from_memory,
    output [7:0] to_memory, address,
    output write,
    output [7:0] testDR, testAC, testAR, testPC, testIR, testBus
    );    
     
     // Ara sinyaller
    wire IR_Load;
    wire DR_Load, PC_Load, AR_Load, AC_Load;
    wire DR_Inc, AC_Inc, PC_Inc;
    wire write_en;
    wire [2:0] alu_sel;
    wire [1:0] bus_sel;
    wire [7:0] IR_Value, to_mem, adr, tDR, tAC, tAR, tPC, tIR, tBus;
    wire [3:0] CR_Value;
    
    assign write=write_en;
    
    control_unit control(
        .clk(clk),
        .rst(rst),
        .sel_in(sel_in),
        .IR_Value(IR_Value),
        .CR_Value(CR_Value),  
        //output      
        .IR_Load(IR_Load),
        .DR_Load(DR_Load),
        .PC_Load(PC_Load),
        .AR_Load(AR_Load),
        .AC_Load(AC_Load),
        .DR_Inc(DR_Inc),
        .AC_Inc(AC_Inc),
        .PC_Inc(PC_Inc),
        .write_en(write_en),
        .alu_sel(alu_sel),
        .bus_sel(bus_sel)        
    );
    
    data_path path (
        .clk(clk),
        .rst(rst),
        .IR_Load(IR_Load),
        .DR_Load(DR_Load),
        .PC_Load(PC_Load),
        .AR_Load(AR_Load),
        .AC_Load(AC_Load),
        .DR_Inc(DR_Inc),
        .AC_Inc(AC_Inc),
        .PC_Inc(PC_Inc),
        .alu_sel(alu_sel),
        .bus_sel(bus_sel),
        .from_memory(from_memory),
        //output
        .to_memory(to_memory),
        .address(address),
        .IR_Value(IR_Value),
        .CR_Value(CR_Value),
        //test amaçlý
        .tDR(testDR), 
        .tAC(testAC), 
        .tAR(testAR),
        .tPC(testPC),
        .tIR(testIR),
        .tBus(testBus)
    );
     
        
endmodule
