module spi_sclk(
    input clk,
    input reset,
    input sclk_enable,

    output reg on
);

reg [12:0] count;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        count<=0;
        on<=0;
    end

    else  if (sclk_enable)
    begin
        if (count==49)
        begin
            count<=0;
            on<=~on;
        end

        else
        begin
            count<=count+1;
        end

        else
        begin
            count<=count+1;
        end
    end

    else
    begin
        count<=0;
        on<=0;
    end
end
endmodule