module spi_bit_counter(
    input sclk,
    input reset,
    input bit_enable,

    output reg bit_done
);

reg [2:0]  counter;

always @(posedge sclk or posedge reset)
begin
    if(reset)
    begin
        counter<=0;
        bit_done<=0;
    end

    else if (bit_enable)
    begin
        if (counter==7)
        begin
            counter<=0;
            bit_done<=1;
        end

        else
        begin
            counter<=counter+1;
            bit_done<=0;
        end
    end

    else
    begin
        bit_done<=0;
    end
end
endmodule