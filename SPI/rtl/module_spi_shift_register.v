module spi_shift_regsiter(
    input sclk,
    input reset,
    input shift_enable,
    input load,
    input [7:0] data_in,

    output mosi
);

reg [7:0] shift_reg;

assign mosi=shift_reg[7]

always  @(negedge sclk or posedge reset)
begin
    if(reset)
    begin
        shift_reg<=0;
    end

    else  if (load)
    begin
        shift_reg<=data_in;
    end

    else_if(shift_enable)
    begin
        shift_reg<=shift_reg<<1;
    end
end
endmodule
