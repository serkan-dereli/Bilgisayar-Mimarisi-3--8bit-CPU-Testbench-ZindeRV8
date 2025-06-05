module ram #(
    parameter DATA_WIDTH = 8,   
    parameter ADDR_WIDTH = 8)
    (input  clk,       // Saat sinyali
    input  we,        // Yazma enable (1: yazma, 0: okuma)
    input  [ADDR_WIDTH-1:0] addr,      // Bellek adresi
    input  [DATA_WIDTH-1:0] din,       // Yazýlacak veri
    output [DATA_WIDTH-1:0] dout       // Okunan veri
);

    // RAM dizisi
    reg [DATA_WIDTH-1:0] bellek [0:(1<<ADDR_WIDTH)-1];
    reg [DATA_WIDTH-1:0] data;

    always @(posedge clk) begin
        if (we==1'b1) begin 
            bellek[addr] <= din;  // Yazma islemi
        end
        else begin 
            data <= bellek[addr];  // Okuma islemi
         end
    end
    
    assign dout=data;

endmodule
