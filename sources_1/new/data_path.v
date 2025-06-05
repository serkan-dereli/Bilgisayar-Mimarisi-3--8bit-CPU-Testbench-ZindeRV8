//10.05.2025

module data_path (
        input clk, rst,
        input IR_Load, DR_Load, PC_Load, AR_Load, AC_Load,
        input DR_Inc, AC_Inc, PC_Inc,
        input [2:0] alu_sel,
        input [1:0] bus_sel,
        input [7:0] from_memory,
        output [7:0] to_memory, address, IR_Value,
        output [3:0] CR_Value,
        //test out
        output [7:0] tDR, tAC, tAR, tPC, tIR, tBus
    );
    
    reg [7:0] IR, DR, AC, AR, PC;
    //reg [3:0] CR;
    wire [7:0] alu_result, bus;
    
    //kaydedici içerigini BUS a aktarýr
    //DR: 00
    //AC: 01
    //PC: 10
    assign bus = (bus_sel==2'b00) ? DR :
                           (bus_sel==2'b01) ? AC : 
                           (bus_sel==2'b10) ? from_memory : PC; 
                           //PC için bus_sel=11
                           
    assign tIR=IR;
    assign tBus=bus;
    assign IR_Value = IR;
    //assign CR_Value = CR;  
    assign to_memory = bus;
    assign address = AR;
    assign tDR = DR;
    assign tPC = PC;
    assign tAC = AC;
    assign tAR = AR;
    assign tIR = IR;
    assign tBus = bus;
    
    //IR kaydedici yükleme
    always @(posedge clk)
    begin
        if(rst==1'b0) begin
            IR<=8'h00;
        end
        else begin
            if(IR_Load==1'b1) begin
                IR<=bus;
            end
        end    
    end
    
    //DR kaydedici yükleme
    always @(posedge clk)
    begin
        if(rst==1'b0) begin
            DR<=8'h00;
        end
        else begin
            if(DR_Load==1'b1) begin
                DR<=bus;
            end
            else if(DR_Inc==1'b1) begin
                DR<=DR+1'b1;
            end
        end    
    end
        
    //PC kaydedici yükleme
    always @(posedge clk)
    begin
        if(rst==1'b0) begin
            PC<=8'h10;
        end
        else begin
            if(PC_Load==1'b1) begin
                PC<=bus;
            end
            else if(PC_Inc==1'b1) begin
                PC<=PC+1'b1;
            end
        end    
    end
    
    //AR kaydedici yükleme
    always @(posedge clk)
    begin
        if(rst==1'b0) begin
            AR<=8'h00;
        end
        else begin
            if(AR_Load==1'b1) begin
                AR<=bus;
            end
        end    
    end
    
    //AC=0
    always @(posedge clk)
    begin
        if(rst==1'b0) begin
            AC<=8'h00;
        end
        else if(AC_Inc==1'b1) begin
                AC<=AC+1'b1;
        end        
        else if(AC_Load==1'b1) begin
                AC<=AC+DR;
        end        
    end
    
    alu alu_uut (        
        .islem_in(alu_sel),
        .s1_in(AC),
        .s2_in(DR),
        .s_out(alu_result)
    );
endmodule
