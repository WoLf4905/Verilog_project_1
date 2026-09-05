class uart_monitor;

    virtual uart_if.TB vif;
    mailbox #(uart_transaction) mon2sb;

    function new(
        virtual uart_if.TB vif,
        mailbox #(uart_transaction) mon2sb
    );

        this.vif = vif;
        this.mon2sb = mon2sb;

    endfunction

    task monitor();
        uart_transaction tx;
        forever
        begin
            @(negedge vif.tx);
            tx=new();

            repeat(2604)
                @(posedge vif.clk);
            
            if (vif.tx != 1'b0) 
            begin
                $display("ERROR: Invalid start bit");
                continue;
            end

            repeat(5208)
                @(posedge vif.clk);
            
            for (int i = 0; i < 8; i++) 
            begin
                tx.data[i] = vif.tx;
                repeat(5208)
                    @(posedge vif.clk);
            end

            if (vif.tx != 1'b1)
                $display("ERROR: Invalid stop bit");
            else
            begin
                $display("MONITOR: Received data = %h", tx.data);
                mon2sb.put(tx);
            end
        end
    endtask
endclass