interface uart_if;
    logic clk;
    logic reset;
    logic tx_start;
    logic tx_data;
    logic tx;

    modport DUT(
        input clk,
        input reset,
        input tx_start,
        input tx_data,
        output tx

    );

    modport TB(
        output clk,
        output reset,
        output tx_start,
        output tx_data,
        input tx
    );
endinterface