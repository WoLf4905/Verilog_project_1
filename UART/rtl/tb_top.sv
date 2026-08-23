module tb_top;

    uart_if uart_bus();

    uart_tx dut (
        .clk     (uart_bus.clk),
        .reset   (uart_bus.reset),
        .tx_start(uart_bus.tx_start),
        .tx_data (uart_bus.tx_data),
        .tx      (uart_bus.tx)
    );

    uart_driver driver;
    uart_transaction tx;
    uart_monitor monitor;

    initial begin
        uart_bus.clk = 0;

        forever
            #10 uart_bus.clk = ~uart_bus.clk;
    end

    initial begin

        uart_bus.reset   = 1;
        uart_bus.tx_start = 0;
        uart_bus.tx_data  = 8'h00;

        repeat(5)
            @(posedge uart_bus.clk);

        uart_bus.reset = 0;

    end

    initial 
    begin

        driver = new(uart_bus);
        monitor = new(uart_bus);

        tx = new();
        tx.data = 8'hA5;

        fork
            monitor.monitor();
        join_none

        wait(uart_bus.reset == 0);

        driver.drive(tx);

    end

endmodule 