class uart_generator;

    mailbox #(uart_transaction) gen2drv;
    mailbox #(uart_transaction) exp2sb;

    function new(mailbox #(uart_transaction) gen2drv,mailbox #(uart_transaction) exp2sb);
        this.gen2drv = gen2drv;
        this.exp2sb = exp2sb;
    endfunction

    task run();
        uart_transaction tx;
        uart_transaction expected;

        repeat (4) begin
            tx = new();
            tx.data = $urandom_range(0, 255);
            expected = new();
            expected.data = tx.data;
            exp2sb.put(expected);
            gen2drv.put(tx);
        end
    endtask
endclass