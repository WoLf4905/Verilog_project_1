module tb_top;

    uart_if uart_bus();

    uart_tx dut (
        .clk     (uart_bus.clk),
        .reset   (uart_bus.reset),
        .tx_start(uart_bus.tx_start),
        .tx_data (uart_bus.tx_data),
        .tx      (uart_bus.tx),
        .tx_busy (uart_bus.tx_busy)
    );

    uart_driver driver;
    // uart_transaction tx;
    // uart_transaction expected;
    uart_monitor monitor;
    uart_generator generator;
    uart_scoreboard scoreboard;
    mailbox #(uart_transaction) gen2drv;
    mailbox #(uart_transaction) mon2sb;
    mailbox #(uart_transaction) exp2sb;
    

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
        mon2sb = new();
        exp2sb = new();
        gen2drv = new();

        driver = new(uart_bus,gen2drv);
        generator = new(gen2drv,exp2sb);
        monitor = new(uart_bus,mon2sb);
        scoreboard = new(mon2sb, exp2sb);

        fork
            generator.run();
            driver.run();
            monitor.monitor();
            scoreboard.run();
        join_none

        wait(uart_bus.reset == 0);

        

    end

endmodule 