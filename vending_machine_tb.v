module vending_machine_tb();
	reg clk, rst;
	reg money_5, money_10, money_20, money_50, money_100;
	reg [2:0] ColdDrink, DairyMilk, Biscuit, RedBull, Chocolate;
	reg purchase;
	wire [2:0] rs_5, rs_10, rs_20, rs_50, rs_100;
	wire item_out;
	wire [3:0] item_count, ColdDrink_count, DairyMilk_count, Biscuit_count, RedBull_count, Chocolate_count;

vending_machine dut(clk, rst, 
	money_5, money_10, money_20, money_50, money_100, 
	ColdDrink, DairyMilk, Biscuit, RedBull, Chocolate,
	purchase,
	rs_5, rs_10, rs_20, rs_50, rs_100,
	item_out, item_count, ColdDrink_count, DairyMilk_count, Biscuit_count, RedBull_count, Chocolate_count );

always @(posedge clk) begin
	#1
	$display("money in : Rs5=%b, Rs10=%b, Rs20=%b, Rs50=%b, Rs100=%b | item selected : ColdDrink=%0d, DairyMilk=%0d, Biscuit=%0d, RedBull=%0d, Chocolate=%0d", money_5, money_10, money_20, money_50, money_100, ColdDrink, DairyMilk, Biscuit, RedBull, Chocolate);
	$display("purchase=%b", purchase);
	$display("change out : rs_5=%0d, rs_10=%0d, rs_20=%0d, rs_50=%0d, rs_100=%0d | item_count=%0d  | item_out=%b", rs_5, rs_10, rs_20, rs_50, rs_100, item_count, item_out);
	$display();
end

initial begin
	$dumpfile("wave_vending_machine.vcd");
	$dumpvars();
end

always #5 clk = ~clk;

initial begin
	clk=0; rst=0;
	money_5=0; money_10=0; money_20=0; money_50=0; money_100=0;
	ColdDrink=0; DairyMilk=0; Biscuit=0; RedBull=0; Chocolate=0;
	purchase=0;
	#10 rst=1;
	
	//case : 1
	//entered Rs.75 and purchase one red-bull
	//money in
	#10 money_5=1; money_20=1; money_50=1;
	#10 money_5=0; money_20=0; money_50=0;
	//select item
	#10 RedBull=1;
	#10 RedBull=0;

	#50

	//case : 2
	//entered Rs.100 and and purchase one chocolate
	//not able to purchase so went back to take_input state and can enter
	//more money or get back that Rs.100
	//money in
	#10 money_100=1;
	#10 money_100=0;
	//select item
	#10 Chocolate=1;
	#10 Chocolate=0;
	//get back entered money
	#20 purchase=1;  #10 purchase=0;

	#50

	//case : 3
	//entered Rs.250 and purchase two redbull, still have some change so
	//buy one cold drink
	//money in
	#10 money_50=0; money_100=1;
	#10 money_50=1; money_100=0;
	#10 money_50=0; money_100=1;
	#10 money_50=0; money_100=0;
	//select item
	#10 RedBull=2;
	#10 RedBull=0;
	//select again
	#10 ColdDrink=1;
	#10 ColdDrink=0;
	//purchase
	#20 purchase=1;  #10 purchase=0;

	#50

	//case : 4
	//entered Rs.200 and purchase one chocolate, still have money so try
	//to purchase another chocolate
	//but didn'y have enough change so only get one chocolate and
	//remaining change 
	//money in
	#10 money_50=1; money_100=0;
	#10 money_50=0; money_100=1;
	#10 money_50=1; money_100=0;
	#10 money_50=0; money_100=0;
	//select item
	#10 Chocolate=1;
	#10 Chocolate=0;
	//select again
	#10 Chocolate=1;
	#10 Chocolate=0;
	//purchase
	#20 purchase=1;  #10 purchase=0;
	
	
	#50 $finish;
end

endmodule
