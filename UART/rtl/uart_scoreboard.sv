class uart_scoreboard;

    mailbox #(uart_transaction) mon2sb;

    function new(mailbox #(uart_transaction) mon2sb);
        this.mon2sb = mon2sb;
    endfunction

    task run();

        uart_transaction actual;

        forever begin

            mon2sb.get(actual);

            $display("SCOREBOARD: Received = %h", actual.data);

        end

    endtask

endclass