class uart_driver;
    virtual uart_if.TB vif;
    mailbox #(uart_transaction) gen2drv;

    function new(virtual uart_if.TB vif,mailbox #(uart_transaction) gen2drv);
        this.vif=vif;
        this.gen2drv = gen2drv;
    endfunction

    task run();

        uart_transaction tx;
        forever begin
            gen2drv.get(tx);
            drive(tx);
        end

    endtask

    task drive(uart_transaction tx);
        wait(vif.reset == 0);
        wait(vif.tx_busy == 0);
        @(negedge vif.clk);
        vif.tx_data=tx.data;
        vif.tx_start=1'b1;
        @(negedge vif.clk);
        vif.tx_start=1'b0;
    endtask
endclass