interface uart_if;
    logic clk;
    logic reset;
    logic tx_start;
    logic [7:0] tx_data;
    logic tx;
    logic tx_busy;

    modport DUT(
        input clk,
        input reset,
        input tx_start,
        input tx_data,
        output tx,
        output tx_busy

    );

    modport TB(
        output clk,
        output reset,
        output tx_start,
        output tx_data,
        input tx,
        input tx_busy
    );
endinterface