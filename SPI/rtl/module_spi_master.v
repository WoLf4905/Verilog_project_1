module spi_master(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,

    output sclk,
    output mosi,
    output cs
);

wire sclk_enable;
wire shift_enable;
wire bit_enable;
wire bit_done;
wire load;
wire sclk_on;

assign sclk=sclk_on;

spi_fsm fsm(
    .clk(clk),
    .reset(reset),
    .start(start),
    .bit_done(bit_done),

    .load(load),
    .sclk_enable(sclk_enable),
    .shift_enable(shift_enable),
    .bit_enable(bit_enable),
    .cs(cs)
);

spi_sclk sclk_gen(
    .clk(clk),
    .reset(reset),
    .sclk_enable(sclk_enable),

    .on(sclk_on)
);

spi_shift_register shift_register(
    .sclk(sclk_on),
    .reset(reset),
    .shift_enable(shift_enable),
    .load(load),
    .data_in(data_in),
    .mosi(mosi)
);

spi_bit_counter bit_counter(
    .sclk(sclk_on),
    .reset(reset),
    .bit_enable(bit_enable),

    .bit_done(bit_done)
);
endmodule


