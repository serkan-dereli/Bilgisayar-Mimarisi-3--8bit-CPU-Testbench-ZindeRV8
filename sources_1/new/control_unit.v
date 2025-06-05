//12.05.2025, kontrol ünitesi tasarýmý, 
//bilgisayar mimarileri dersi için
//kontrol biriminde ne olmalý
//1) durumlar (state), fetch, decode, execute
//2) her komutun adýmý da durum olarak iþlemeli (komutun icrasý)
//3) komutlarýn hex kodu tanýmlanmalý

module control_unit(
        input clk, rst, sel_in,
        input [7:0] IR_Value,
        input [3:0] CR_Value,
        output reg IR_Load, DR_Load, PC_Load, AR_Load, AC_Load,
        output reg DR_Inc, AC_Inc, PC_Inc, write_en,
        output reg [2:0] alu_sel,
        output reg [1:0] bus_sel
    );
    
    reg [7:0] current_state, next_state;
    
    //ORTAK FETCH ve KOMUTLARA AÝT DECODE ve EXECUTE AÞAMALARI
    localparam reg[7:0] 
        S_FETCH_0 = 8'd0, 
        S_FETCH_1 = 8'd1,
        S_FETCH_2 = 8'd2,
        S_DECODE_3 = 8'd3,
    
        //LDA IMM A: 10
        S_LDA_IMM_4 = 8'd10,
        S_LDA_IMM_5 = 8'd11,
        S_LDA_IMM_6 = 8'd12,
        S_LDA_IMM_7 = 8'd13,
        
        //LDA ADR A: 20
        S_LDA_ADR_4 = 8'd20,
        S_LDA_ADR_5 = 8'd21,
        S_LDA_ADR_6 = 8'd22,
        S_LDA_ADR_7 = 8'd23,
        S_LDA_ADR_8 = 8'd24, 
        S_LDA_ADR_9 = 8'd25,
        
        //  STA ADR A: 30
        S_STA_ADR_4 = 8'd30,
        S_STA_ADR_5 = 8'd31,
        S_STA_ADR_6 = 8'd32,
        S_STA_ADR_7 = 8'd33,
        
        //ADD_ADR_A: 40
        S_ADD_ADR_4 = 8'd40,
        S_ADD_ADR_5 = 8'd41,
        S_ADD_ADR_6 = 8'd42,
        S_ADD_ADR_7 = 8'd43,
        S_ADD_ADR_8 = 8'd44,
        S_ADD_ADR_9 = 8'd45,
        
        //ADD_IMM_A: 50
        S_ADD_IMM_4 = 8'd50,
        S_ADD_IMM_5 = 8'd51,
        S_ADD_IMM_6 = 8'd52,
        S_ADD_IMM_7 = 8'd53,
        
        //S_INC_A: 60
        S_INC_A_4 = 8'd60,
        S_BRK_4 = 8'h61;
        
    //komutlar------ IR_Value deðeri ile gelecek----------
    localparam reg[7:0]
        // I tip: 3
        LDA_IMM = 8'h32,        
        ADD_IMM = 8'h34,
        
        // S tip: 4
        LDA_ADR = 8'h42,
        STA_ADR = 8'h44,
        ADD_ADR = 8'h46,
        
        //  R tip: 5
        INC_A = 8'h52,
        BRK = 8'h0f,
        
        // ALU komutlarý
        ADD_ALU = 8'h80,
        SUB_ALU = 8'h82,
        AND_ALU = 8'h84;
       
    //current state logic
    always @(posedge clk)
    begin
        if(rst==1'b0) begin
            current_state <= S_FETCH_0;
        end
        else begin
            if(sel_in==1'b0) begin
                current_state <= next_state;
            end
        end
    end
    
    // next state logic, sonraki durum güncellemesi
    always @(current_state, IR_Value)
    begin
        case(current_state)
            S_FETCH_0: begin
                next_state = S_FETCH_1;
            end
            
            S_FETCH_1: begin
                next_state = S_FETCH_2;
            end
            
            S_FETCH_2: begin
                next_state = S_DECODE_3;
            end
            
            S_DECODE_3: begin
                if(IR_Value == LDA_IMM)
                begin
                    next_state = S_LDA_IMM_4;
                end
                else if(IR_Value == ADD_IMM)
                begin
                    next_state = S_ADD_IMM_4;
                end
                else if(IR_Value == LDA_ADR)
                begin
                    next_state = S_LDA_ADR_4;
                end
                else if(IR_Value == STA_ADR)
                begin
                    next_state = S_STA_ADR_4;
                end
                else if(IR_Value == ADD_ADR)
                begin
                    next_state = S_ADD_ADR_4;
                end
                else if(IR_Value == INC_A)
                begin
                    next_state = S_INC_A_4;
                end
                else if(IR_Value == BRK)
                begin
                    next_state = S_BRK_4;
                end
                else begin
                    next_state = S_FETCH_0;
                end                
            end
            
            //------------------------------------
            S_LDA_IMM_4: begin
                next_state = S_LDA_IMM_5;
            end
            
            S_LDA_IMM_5: begin
                next_state = S_LDA_IMM_6;
            end
            
            S_LDA_IMM_6: begin
                next_state = S_LDA_IMM_7;
            end
            
            S_LDA_IMM_7: begin
                next_state = S_FETCH_0;
            end
            //---------------------------------------
            S_ADD_IMM_4: begin
                next_state = S_ADD_IMM_5;
            end
            S_ADD_IMM_5: begin
                next_state = S_ADD_IMM_6;
            end
            S_ADD_IMM_6: begin
                next_state = S_ADD_IMM_7;
            end
            S_ADD_IMM_7: begin
                next_state = S_FETCH_0;
            end
            //--------------------------------------------
            S_LDA_ADR_4: begin
                next_state = S_LDA_ADR_5;
            end
            S_LDA_ADR_5: begin
                next_state = S_LDA_ADR_6;
            end
            S_LDA_ADR_6: begin
                next_state = S_LDA_ADR_7;
            end
            S_LDA_ADR_7: begin
                next_state = S_LDA_ADR_8;
            end
            S_LDA_ADR_8: begin
                next_state = S_LDA_ADR_9;
            end
            S_LDA_ADR_9: begin
                next_state = S_FETCH_0;
            end
            //----------------------------------------------
            S_STA_ADR_4: begin
                next_state = S_STA_ADR_5;
            end
            S_STA_ADR_5: begin
                next_state = S_STA_ADR_6;
            end
            S_STA_ADR_6: begin
                next_state = S_STA_ADR_7;
            end
            S_STA_ADR_7: begin
                next_state = S_FETCH_0;
            end
            //---------------------------------------------
            S_ADD_ADR_4: begin
                next_state = S_ADD_ADR_5;
            end
            S_ADD_ADR_5: begin
                next_state = S_ADD_ADR_6;
            end
            S_ADD_ADR_6: begin
                next_state = S_ADD_ADR_7;
            end
            S_ADD_ADR_7: begin
                next_state = S_ADD_ADR_8;
            end
            S_ADD_ADR_8: begin
                next_state = S_ADD_ADR_9;
            end
            S_ADD_ADR_9: begin
                next_state = S_FETCH_0;
            end
            //------------------------------------------
            S_INC_A_4: begin
                next_state = S_FETCH_0;
            end
            S_BRK_4: begin
                next_state = S_FETCH_0;
            end            
            default: begin
                next_state = S_FETCH_0;
            end
        endcase
    end    
    // case sonu-------------------------
    
    //output logic
    always @(current_state)
    begin
        IR_Load=1'b0;
        AR_Load=1'b0;
        PC_Load=1'b0;
        AC_Load=1'b0;
        DR_Load=1'b0;
        bus_sel=1'b0;
        alu_sel=2'b00;
        write_en=1'b0;
        PC_Inc=1'b0;
        DR_Inc=1'b0;
        
        case(current_state)
            S_FETCH_0: begin
                bus_sel=2'b11;
                AR_Load=1'b1;
            end
            
            S_FETCH_1: begin
                PC_Inc=1'b1;
            end
            
            S_FETCH_2: begin
                bus_sel=2'b10; //bus<<from_memory
                IR_Load=1;
            end
            
            S_DECODE_3: begin
                //OPCODE yukarýdaki always bloðunda çözüldü ve 
                //sonraki durumu geçildi
            end
            //------------------------------------
            S_LDA_IMM_4: begin
                //OPERAND oku
                bus_sel=2'b11;
                AR_Load=1'b1;
            end
            
            S_LDA_IMM_5: begin
                PC_Inc=1'b1;
            end
            
            S_LDA_IMM_6: begin
                bus_sel=2'b10; //bus<<from_memory
                DR_Load=1;
            end
            
            S_LDA_IMM_7: begin
                AC_Load=1;
                alu_sel=3'b111;
            end
            //---------------------------------------
            S_ADD_IMM_4: begin
                //OPERAND oku
                bus_sel=2'b11;
                AR_Load=1'b1;
            end
            S_ADD_IMM_5: begin
                PC_Inc=1'b1;
            end
            S_ADD_IMM_6: begin
                DR_Load=1;
            end
            S_ADD_IMM_7: begin
                alu_sel=3'b000;
            end
            //--------------------------------------------
            S_LDA_ADR_4: begin
                //OPERAND oku
                bus_sel=2'b11;
                AR_Load=1'b1;
            end
            S_LDA_ADR_5: begin
                PC_Inc=1'b1;
            end
            S_LDA_ADR_6: begin
                AR_Load=1;
            end
            S_LDA_ADR_7: begin
                //boþ
            end
            S_LDA_ADR_8: begin
                DR_Load=1;
            end
            S_LDA_ADR_9: begin
                AC_Load=1;
            end
            //----------------------------------------------
            S_STA_ADR_4: begin
                //OPERAND oku
                bus_sel=2'b11;
                AR_Load=1'b1;
            end
            S_STA_ADR_5: begin
                PC_Inc=1'b1;
            end
            S_STA_ADR_6: begin
                bus_sel=2'b10;
                AR_Load=1'b1;
            end
            S_STA_ADR_7: begin
                bus_sel=2'b01;
                write_en=1'b1;
            end
            //---------------------------------------------
            S_ADD_ADR_4: begin
                //OPERAND oku
                bus_sel=2'b11;
                AR_Load=1'b1;
            end
            S_ADD_ADR_5: begin
                PC_Inc=1'b1;
            end
            S_ADD_ADR_6: begin
                bus_sel=2'b10; //bus=from_memory
                AR_Load=1'b1;
            end
            S_ADD_ADR_7: begin
                //boþ
            end
            S_ADD_ADR_8: begin
                bus_sel=2'b10; //bus=from_memory
                DR_Load=1'b1;
            end
            S_ADD_ADR_9: begin
                AC_Load=1;
                alu_sel=3'b000;
            end
            //------------------------------------------
            S_INC_A_4: begin
                AC_Inc=1'b1;
            end
            
            default: begin
                IR_Load=1'b0;
                AR_Load=1'b0;
                PC_Load=1'b0;
                bus_sel=1'b0;
                alu_sel=2'b00;
                write_en=1'b0;
                AC_Load=1'b0;
                AC_Inc=1'b0;
                PC_Inc=1'b0;
            end
        endcase
    end    
    
endmodule