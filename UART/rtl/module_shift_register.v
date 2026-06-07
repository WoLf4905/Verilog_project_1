module uart_shift_register(
    input clk,
    input reset,
    input load,
    input shift_enable,
    input [7:0] data_in,
    output tx_bit
);

reg[7:0] shift_reg;

always @(posedge clk or posedge reset)
begin
    if(reset)
        shift_reg<=0;
    else if(load)
        shift_reg<=data_in;
    else if (shift_enable)
        shift_reg<=shift_reg >>1;
end

assing tx_bit = shift_reg[0]
endmodule