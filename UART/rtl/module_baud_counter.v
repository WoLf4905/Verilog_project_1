module uart_baud_counter(
    input clk,
    input reset,
    input baud_enable,

    output reg baud_done
);

reg [12:0] count;
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        count<=0;
        baud_done<=0;
    end

    else if(baud_enable)
    begin
        //5207  orignally
        if(count==10)
        begin
            count<=0;
            baud_done<=1;
        end

        else
        begin
            count<=count+1;
            baud_done<=0;
        end
    end

    else
    begin
        count<=0;
        baud_done<=0;
    end
end
endmodule