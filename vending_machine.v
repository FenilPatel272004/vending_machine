//money input: 5, 10, 20, 50, 100
//item & cost: ColdDrink = 10, 
//	       DairyMilk = 45, 
//	       Biscuit = 5, 
//	       RedBull = 75, 
//	       Chocolate = 135


module vending_machine(
	input clk,
	input rst,
	input money_5, money_10, money_20, money_50, money_100,
	input [2:0] ColdDrink, DairyMilk, Biscuit, RedBull, Chocolate,
	input purchase,
	output reg [2:0] rs_5, rs_10, rs_20, rs_50, rs_100,
	output item_out,
	output reg [3:0] item_count, ColdDrink_count, DairyMilk_count, Biscuit_count, RedBull_count, Chocolate_count
	);

	integer amount, cost, change;

	reg [3:0] state, next_state;

	//state parameter
	parameter ideal=0,
		take_input=1,
		calculation=2,
		give_change=3,
		final=4;

	//state change
	always @(posedge clk or rst) begin
		if(~rst)
			state <= ideal;
		else
			state <= next_state;
	end


	//next_state selection
	always @(*) begin
		case(state)
			ideal: next_state = ({money_5,money_10,money_20,money_50,money_100}>0) ? take_input : ideal;

			take_input: next_state = purchase ? give_change : ({ColdDrink, DairyMilk, Biscuit, RedBull, Chocolate}==0) ? take_input : calculation;

			calculation: next_state = (change > 0) ? take_input : final;
			
			give_change: next_state = (change == 0) ? final : give_change;

			final: next_state = ideal;
		endcase
	end


	// state calculation
	always @(state or {money_5,money_10,money_20,money_50,money_100} or {ColdDrink, DairyMilk, Biscuit, RedBull, Chocolate} or purchase) begin
		case(state)
			ideal: begin
				amount = 0;
				cost = 0;
				change = 0;
				item_count=0;
				{ColdDrink_count, DairyMilk_count, Biscuit_count, RedBull_count, Chocolate_count} = 0;
				{rs_5, rs_10, rs_20, rs_50, rs_100}=0;
			end


			take_input: begin
				amount = amount + (5*money_5) + (10*money_10) + (20*money_20) + (50*money_50) + (100*money_100);
				if(purchase) change = amount;
			end


			calculation: begin
				cost = (ColdDrink*10) + (DairyMilk*45) + (Biscuit*5) + (RedBull*75) + (Chocolate*135);
				change = amount - cost;
				if(change>=0 && cost!=0) begin
					item_count = item_count + ColdDrink+DairyMilk+Biscuit+RedBull+Chocolate;
					 ColdDrink_count = ColdDrink_count + ColdDrink; 
					 DairyMilk_count = DairyMilk_count + DairyMilk; 
					 Biscuit_count = Biscuit_count + Biscuit; 
					 RedBull_count = RedBull_count + RedBull; 
					 Chocolate_count = Chocolate_count + Chocolate;
				end
				if(change < 0) change = amount;
				amount = change;
			end


			give_change: begin
				rs_100 = change / 100;     change = change % 100;
				rs_50 = change / 50;	   change = change % 50;
				rs_20 = change / 20;	   change = change % 20;
				rs_10 = change / 10;	   change = change % 10;
				rs_5 = change / 5;	   change = change % 5;
			end


			final: begin
				{rs_5, rs_10, rs_20, rs_50, rs_100}=0;
			end
		endcase	
	end

	assign item_out = (state==final && item_count>0); 

endmodule
