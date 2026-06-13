module spi_fsm(
    input clk,
    input reset,
    input start,
    input bit_done,

    output reg load,
    output reg sclk_enable,
    output reg shift_enable,
    output reg bit_enable,
    output reg cs 
);

parameter IDLE =2'b00;
parameter LOAD =2'b01;
parameter TRANSFER =2'b10;

reg[1:0] state;
reg [1:0] next_state;

 always @ (posedge clk or posedge reset)
 begin
    if (reset)
    begin
        state<=IDLE;
    end
    else
    begin
        state<=next_state;
    end
end

always @(*)
begin
    sclk_enable=0;
    shift_enable=0;
    bit_enable=0;
    cs=1;
    load=0;

    next_state=state;

    case(state)
        IDLE:
        begin
            if(start)
            begin
                next_state=LOAD;
            end
        end

        LOAD:
        begin
            load=1;
            cs=0;
            next_state=TRANSFER;
        end

        TRANSFER:
        begin
            sclk_enable=1;
            shift_enable=1;
            bit_enable=1;
            cs=0;

            if (bit_done)
            begin
                next_state=IDLE;
            end
        end
    endcase
end
endmodule
