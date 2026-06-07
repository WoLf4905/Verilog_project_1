module uart_bit_counter(
    input clk,
    input reset,
    input bit_enable,
    
    output reg bit_done
);

reg [2:0] bit_count;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        bit_count<=0;
        bit_done<=0;
    end

    else  if (bit_enable)
    begin
        if (bit_count==7)
        begin
            bit_count<=0;
            bit_done<=1;
        end

        else
        begin
            bit_count<=bit_count+1;
            bit_done<=0;
        end
    end

    else
    begin
        bit_done<=0;
    end
end
endmodule