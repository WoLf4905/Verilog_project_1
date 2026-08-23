class uart_driver;
    virtual uart_if.TB vif;

    function new(virtual uart_if.TB vif);
        this.vif=vif;
    endfunction

    task drive(uart_transaction tx);
        @(negedge vif.clk);
        vif.tx_data=tx.data;
        vif.tx_start=1'b1;
        @(negedge vif.clk);
        vif.tx_start=1'b0;
    endtask
endclass