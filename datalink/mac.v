module Mac(clk, rst, stream_i, stream_o, ack, stb, type_i, type_o, mac_i, mac_o, ETH_PHY_MDC, ETH_PHY_MDIO, ETH_PHY_RST_N, ETH_RXC, ETH_RX_EN, ETH_RXD, ETH_TXC, ETH_TX_EN, ETH_TXD);

    input clk, rst;
    input [7: 0] stream_i;
    input stb;
    input [15: 0] type_i;
    input [47: 0] mac_i;
    input ETH_RXC;
    input ETH_RX_EN;
    input [3: 0] ETH_RXD;
    
    output ETH_TXC;
    output ETH_PHY_RST_N;
    output ETH_TX_EN;
    output reg [3: 0] ETH_TXD;
    output reg ETH_PHY_MDC;
    output reg [7: 0] stream_o;
    output reg ack;
    output reg [15: 0] type_o;
    output reg [47: 0] mac_o;

    inout ETH_PHY_MDIO;

    reg [7: 0] frame[0: 1525];
    reg tx_en, last_tx, rx_en, last_rx;
    reg [9: 0] tx_cnt, rx_cnt;
    reg [7: 0] tx_data, rx_data;

    initial begin
        tx_en = 0;
        rx_en = 0;
        last_tx = 0;
        last_rx = 0;
        tx_cnt = 0;
        rx_cnt = 0;
        tx_data = 0;
        rx_data = 0;
    end

    // sync the transmit clk;
    assign ETH_TXC = clk;
    assign ETH_TX_EN = tx_en;

    // Receive from IP
    always @(posedge clk or negedge clk) begin
         
    end

    // Transmition to PHY
    always @(posedge clk or negedge clk) begin
        if (clk) begin
            // posedge
            
            // maintain the counter
            if (!last_tx && tx_en) begin
                // begin to transmit
                tx_cnt <= 0;
            end else if (tx_en) begin
                tx_cnt <= tx_cnt + 1;
            end

            // transmit data
            if (last_tx && tx_en) begin
                data = frame[tx_cnt];
                ETH_TXD = data[7: 4]
            end
            
            // maintain last state
            last_tx <= tx_en;
        end else begin
            // negedge
            if (last_tx && tx_en) begin
                data = frame[tx_cnt];
                ETH_TXD = data[3: 0];
            end
        end
    end

    // Receive from PHY
    always @(posedge clk or negedge clk) begin
        if (clk) begin
            // posedge 
            
            // maintain the counter
            if (!last_rx && rx_en) begin
                // begin to receive
                rx_cnt <= 0;
            end else if (rx_en) begin
                // receiving
                rx_cnt <= rx_cnt + 1;
            end

            // receive data
            if (last_rx && rx_en) begin
                rx_data[7: 4] = ETH_RXD;
            end

            // maintain the last state
        end else begin
            // negedge
            if (last_rx && rx_en) begin
                rx_data[3: 0] = ETH_RXD;
                frame[rx_cnt] = rx_data;
            end
        end
    end

endmodule
