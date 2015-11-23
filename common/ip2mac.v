module ip2mac(clk, reset, ip, mac_o, found, ip_i, mac_i, wea);
    input wire clk, wea, reset;
    input wire [31:0] ip_i, ip;
    input wire [47:0] mac_i;
    output wire found;
    output wire [47:0] mac_o;

    // only param to change
    parameter HASH_DEPTH = 8;

    // should not modify
    parameter HASH_SIZE = 1 << HASH_DEPTH;
    parameter HASH_LOWER = 32 - HASH_DEPTH;     // big endian

    // bit 0 - 31   : actual ip address
    // bit 32 - 79  : mac address
    // bit 80       : valid
    reg [80:0] hash[0:HASH_SIZE-1];

    task init;
        integer i;
        for (i = 0; i < HASH_SIZE; i = i + 1) hash[i] = 81'b0;
    endtask

    initial begin
        init();
    end

    always @(posedge clk) begin
        if (reset) begin
            init();
        end
        else if (wea) begin
            hash[ip_i[HASH_LOWER + HASH_DEPTH - 1:HASH_LOWER]] <= {1'b1, mac_i, ip_i};
        end
    end

    wire [80:0] hash_line = hash[ip[HASH_LOWER + HASH_DEPTH - 1:HASH_LOWER]];
    assign mac_o =  hash_line[79:32];
    assign found = (hash_line[31:0] == ip) && hash_line[80];
endmodule
