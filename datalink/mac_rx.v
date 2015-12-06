module mac_rx(clk, ctl, reset, rxd, data);

    input clk, ctl, rst;
    input [3: 0] rxd;
    output reg [7: 0] data;

    localparam
        IDLE = 0,
        VALIDATE = 1,
        WAIT_SFD_0 = 2,
        WAIT_SFD_1 = 3,
        DATA = 4,
        DONE = 5;

    // RGMII register
    reg rx_dv, rx_err;

    // internal register
    reg state, state_next;
    reg rx_rising, rx_falling;

    // detect clk rising and falling state
    always @(posedge clk or negedge clk) begin
        if (clk) begin
            // rising
            rx_rising <= 1;
            rx_falling <= 0;
        end else begin
            // falling
            rx_rising <= 0;
            rx_falling <= 1;
        end
    end

    // state transition
    always @(posedge clk or negedge clk) begin
        if (reset) begin
            state <= 0;
        end else begin
            state <= state_next;
        end
    end
    
    // state machine
    always @(*) begin
        state_next = 0;
        case (state)
            IDLE: begin
                if (rx_dv) begin
                    state_next = VALIDATE;
                end else begin
                    state_next = IDLE;
                end
            end
            VALIDATE: begin
                if (rx_falling && !rx_err) begin
                    state_next = WAIT_SFD;
                end else begin
                    state_next = IDLE;
                end
            end
            WAIT_SFD_0: begin
                if (rxd == 4'hd) begin
                    // first 4 bit of SFD
                    state_next = WAIT_SFD_1;
                end else begin
                    state_next = WAIT_SFD_0;
                end
            end
            WAIT_SFD_1: begin
                if (rxd == 4'h5) begin
                    // second 4 bit of SFD
                    state_next = DATA;
                end else begin
                    // shouldn't be here, there must be errors
                    state_next = IDLE;
                end
            end
            DATA: begin
                if (rx_rising && !rx_dv) begin
                    // done receiving
                    state_next = DONE;;
                end else begin
                    // receiving
                    state_next = DATA;
                end
            end
            DONE: begin
                state_next = IDLE;
            end
        endcase
    end

    always @(posedge rx_rising) begin
        
    end

endmodule
