`timescale 1ns / 1ps

//TCL console sorgulamalarý
//belleðin 60 nolu satýrýnda 14(0xe) deðeri olmalýdýr, bunun için aþaðýdaki satýrý TCL konsolda çalýþtýrýnýz.
//get_value /tb_ZindeRV8/tb_cpu/ram256byte/bellek(17)

module tb_ZindeRV8();
    reg clk=0, rst=0, tb_we;
    reg [7:0] tb_adr, tb_data_in;
    reg [7:0] program[0:15], row=8'h10;
    reg [3:0] durum, tb_sel_in, cnt=0;
    
    //output
    //d_out: ram den çýkan veriyi cpu ya aktarýr
    //d_in: cpu dan çýkan veriyi ram a aktarýr.
    wire [7:0] d_out, d_in;
    wire tb_we_out;
    
    //test kaydedicileri
    wire [7:0] r_dr, r_ac, r_ar, r_pc, r_ir, r_bus;
    
    ZindeRV8 tb_cpu(
        .clkn(clk),
        .rstn(rst),
        .we_in(tb_we), 
        .sel_in(tb_sel_in),
        .data_in(tb_data_in), 
        .adr_in(tb_adr),
        //output
        .data_out(d_out), 
        .data_mem_in(d_in),
        .tbDR(r_dr), 
        .tbAC(r_ac), 
        .tbAR(r_ar), 
        .tbPC(r_pc), 
        .tbIR(r_ir), 
        .tbBus(r_bus),
        .we_out(tb_we_out)
    );
    
    initial begin
            #20
            rst = 1'b1;
            durum=0;
            #1000; $finish;
      end
      
      initial begin
            program[0]=8'h32; //opcode
            program[1]=8'h05;
            program[2]=8'h46; //opcode
            program[3]=8'h50;
            program[4]=8'h44; //opcode
            program[5]=8'h60;
            program[6]=8'h0f; //opcode, brk
            program[7]=8'hff; //program sonu, 
      end
      
      always #10 clk = ~clk;
      
      always @(posedge clk)
      begin
            case(durum)
                0: begin
                    //RAM a program yükleniyor
                    tb_we=1;
                    tb_sel_in=1; //belleðe dýþardan yazma yapýlýyor
                    tb_data_in=program[cnt];
                    tb_adr=row;
                    cnt=cnt+1;
                    row=row+1;
                    if(tb_data_in==8'hff) begin
                        tb_adr=8'h50;
                        tb_data_in=9;
                        durum=1;    
                    end
                end
                
                1: begin
                    tb_sel_in=0;
                end
            endcase
      end
    
endmodule
