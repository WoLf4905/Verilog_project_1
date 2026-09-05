class uart_scoreboard;

    mailbox #(uart_transaction) mon2sb;
    mailbox #(uart_transaction) exp2sb;

    function new(mailbox #(uart_transaction) mon2sb, mailbox #(uart_transaction) exp2sb);
        this.mon2sb = mon2sb;
        this.exp2sb = exp2sb;
    endfunction

    task run();

        uart_transaction actual;
        uart_transaction expected;

        forever begin
            exp2sb.get(expected);
            mon2sb.get(actual);

            if (actual.data == expected.data)
                $display("SCOREBOARD: EXPECTED = %h | ACTUAL = %h | PASS",
                    expected.data, actual.data);
            else
                $display("SCOREBOARD: EXPECTED = %h | ACTUAL = %h | FAIL",
                    expected.data, actual.data);

        end

    endtask

endclass