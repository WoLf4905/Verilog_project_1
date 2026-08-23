class uart_monitor;
    virtual uart_if.TB vif;
    function new(virtual uart_if.TB vif);
        this.vif=vif;
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
                $display("MONITOR: Received data = %h", tx.data);
        end
    endtask
endclass