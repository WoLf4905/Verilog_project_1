module uart_tx(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output tx
);

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

wire [1:0] state;
wire baud_done;
wire bit_done;

wire baud_enable;
wire shift_enable;
wire load;
wire bit_enable;

wire tx_bit;

uart_fsm fsm(
    .clk(clk),
    .reset(reset),
    .state(state),
    .start(start),
    .baud_done(baud_done),
    .bit_done(bit_done),

    .baud_enable(baud_enable),
    .shift_enable(shift_enable),
    .load(load),
    .bit_enable(bit_enable)
);

uart_baud_counter baud_ctr(
    .clk(clk),
    .reset(reset),
    .enable(baud_enable),
    .baud_done(baud_done)
);

uart_shift_register shift_reg(
    .clk(clk),
    .reset(reset),
    .load(load),
    .shift_enable(shift_enable),
    .data_in(data_in),
    .tx_bit(tx_bit)
);

uart_bit_counter bit_ctr(
    .clk(clk),
    .reset(reset),
    .bit_enable(bit_enable),
    .bit_done(bit_done)
);

assign tx =
    (state == IDLE)  ? 1'b1 :
    (state == START) ? 1'b0 :
    (state == DATA)  ? tx_bit :
    (state == STOP)  ? 1'b1 :
                       1'b1;
endmodule