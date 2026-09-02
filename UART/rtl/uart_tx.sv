module uart_tx(
    input logic clk,
    input logic reset,

    input logic tx_start,
    input logic [7:0] tx_data,

    output logic tx,
    output logic tx_busy
);
    typedef enum logic [1:0]{
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state, next_state;

    logic [7:0] shift_reg;
    logic [2:0] bit_count;

    logic [12:0] baud_count;
    logic baud_done;

    logic shift_enable;

    always_ff @(posedge clk)
    begin
        if(reset)
        begin
            baud_count <=13'd0;
        end

        else if(baud_count == 13'd5207)
        begin
            baud_count<=13'd0;
        end

        else
        begin
            baud_count <= baud_count + 1'b1;
        end
    end

    always_ff @(posedge clk)
    begin
        if (reset)
            bit_count<=3'd0;
        else if (state == START && baud_done)
            bit_count <= 3'd0;
        else if(state==DATA && baud_done && bit_count!=3'd7)
            bit_count<=bit_count+1;
    end

    assign baud_done= (baud_count == 13'd5207);
    assign shift_enable= (baud_done && state==DATA && bit_count!=3'd7);

    always_ff @(posedge clk)
    begin
        if (reset)
        begin
            state <= IDLE;
        end

        else
        begin
            state<=next_state;
        end
    end

    always_ff @(posedge clk)
    begin
        if (reset)
        begin
            shift_reg<=8'b0;
        end

        else if (state == START && baud_done)
        begin
            shift_reg<=tx_data;
        end

        else if (shift_enable)
        begin
            shift_reg<=shift_reg >>1;
        end
    end

    always_comb
    begin
        next_state=state;

        case(state)
            IDLE:
            begin
                if(tx_start)
                    next_state=START;
            end

            START:
            begin
                if(baud_done)
                    next_state=DATA;
            end

            DATA:
            begin
                if(baud_done && bit_count==3'd7)
                    next_state=STOP; 
            end

            STOP:
            begin
                if(baud_done)
                    next_state=IDLE;
            end

            default:
                next_state=IDLE;
        endcase
    end

    always_comb
    begin
        case(state)
            IDLE: tx=1'b1;
            START: tx=1'b0;
            DATA: tx=shift_reg[0];
            STOP: tx=1'b1;

            default: tx=1'b1;
        endcase
    end

    assign tx_busy = (state != IDLE);
    
endmodule


