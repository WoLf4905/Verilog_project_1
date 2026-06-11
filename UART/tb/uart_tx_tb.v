module uart_tx_tb;

reg clk;
reg reset;
reg start;
reg [7:0] data_in;

wire tx;


uart_tx dut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .tx(tx)
);



always #10 clk = ~clk;

initial
begin
    clk=0;
    reset=1;
    start=0;
    data_in=8'h00;

    #100;
    reset=0;

    #100;
    data_in=8'h41;

    start=1;
    #20;
    start=0;

    #1000000;

    $finish;
end

initial
begin   
    $dumpfile("uart.vcd");
    $dumpvars(0,uart_tx_tb);
end
endmodule
