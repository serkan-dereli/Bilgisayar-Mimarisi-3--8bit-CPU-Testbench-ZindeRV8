// Tarih: 10.05.2025 

module alu(
    input [2:0] islem_in,
    input [7:0] s1_in, s2_in,
    //output [3:0] nzvc,
    output [7:0] s_out
    );
    
    reg [7:0] sx;    
    assign s_out=sx;
    
    always @(*) begin
        case(islem_in)
            3'b000: begin
                            sx=s1_in+s2_in;
                          end
            3'b001: begin
                            sx=s1_in-s2_in;
                          end
            3'b010: sx=s1_in+1;
            3'b011:  sx=s1_in-1;
            3'b100: sx=s1_in & s2_in;
            3'b101:  sx=s1_in | s2_in;
            3'b110:  sx=~s1_in;
            3'b111:   sx=s2_in;
            default: sx=0;            
        endcase
    end
endmodule