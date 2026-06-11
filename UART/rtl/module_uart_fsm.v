module uart_fsm(
    input clk,
    input reset,
    input start,
    input baud_done,
    input bit_done,

    output reg baud_enable,
    output reg shift_enable,
    output reg load,
    output reg bit_enable,
    output reg [1:0] state
);

parameter IDLE= 2'b00;
parameter START=2'b01;
parameter DATA=2'b10;
parameter STOP=2'b11;

reg [1:0] next_state;

always @(posedge clk or posedge reset)
begin 
    if (reset)
        state<=IDLE;
    else
        state<=next_state;
end 

always @(*)
begin
    baud_enable=0;
    bit_enable=0;
    shift_enable=0;
    load=0;
    next_state=state;

    case(state)
        IDLE:
        begin
            if(start)
            begin
                next_state=START;
                load=1;
            end
        end

        START:
        begin
            baud_enable=1;
            if(baud_done)
            begin
                next_state=DATA;
            end
        end

        DATA:
        begin
            baud_enable=1;
            shift_enable=baud_done;
            bit_enable=baud_done;
            if(bit_done)
            begin
                next_state=STOP;
            end
        end

        STOP:
        begin
            baud_enable=1;
            if(baud_done)
            begin
                next_state=IDLE;
            end
        end
    endcase
end
endmodule