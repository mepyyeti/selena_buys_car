#!/usr/bin/env ruby
#selena_buys_car.rb

class Car
	#easy version= attr_accessor :make, :price
	attr_reader :make, :purch_price
	
	def make=(make)
		if make==""
			raise "make of car can't be empty."
		end
		@make=make
	end
	
	def purch_price=(purch_price)
		if purch_price==""
			raise "please enter number price."
		end
		@purch_price=purch_price
	end
	
	def initialize(make, purch_price)
		self.make = make
		self.purch_price = purch_price
	end
	
	def purchase_data
		formatted_price=format("$%.2f", @purch_price)
		puts "this #{@make} costs #{formatted_price}"
		my_write_data = File.open('my_write_data.txt','w+')
		my_write_data.write("#{@make} costs #{formatted_price}\n\t")
		my_write_data.close
	end
end

class Trade < Car
	attr_reader :reconditioning, :other
	attr_accessor :value, :profit_obj, :final_price_formatted, :license
	
	def reconditioning=(reconditioning)
		if reconditioning < 0
			raise "reconditioning can't be negative. Repairs must be positive."
		end
		@reconditioning= reconditioning
	end
	
	def other=(other=0.00)
		@other = other
	end

	def initialize(make,purch_price,value,reconditioning,profit_obj,license,other)
		super(make,purch_price)
		self.value = value
		self.reconditioning=reconditioning
		self.profit_obj=profit_obj
		self.license=license
		self.other=other
	end
	
	def trade_markup
		puts "your trade is a #{@make}."
		resell_price = @value + @reconditioning + @profit_obj
		resell_price_formatted = format("$%.2f", @value + @reconditioning + @profit_obj + @license + @other)
		percentage = format("%.2f",((@profit_obj / resell_price) * 100))
		puts "your total mark up for the #{@make} trade is #{resell_price_formatted}."
		puts "this requires a #{percentage} % markup."
	end

	def final_price_formatted
		self.final_price_formatted = format("%.2f", @purch_price - @value)
	end

	def final_price
		purch_price_formatted = format("%.2f", @purch_price)
		puts "purchase price is #{purch_price_formatted}."
		puts "your final PURCHASE PRICE is $#{@final_price_formatted}."
	end
	
	def trade_data
		my_write_data=File.open('my_write_data.txt','a+')
		new_value = format("%.2f",@value)
		my_write_data.write("#{@make} car is valued at #{new_value}. ")
		my_write_data.write("after your trade, your new cost is #{@final_price_formatted}.")
		my_write_data.close
	end
end

go = true

while go
	print "please enter a make >> "
	entry = gets.chomp.to_s
	
	print "please enter your purchase price >> "
	sold = gets.chomp.to_f
	
	my_car = Car.new(entry,sold)
	my_car.purchase_data
	
	print "are you making a trade? >>"
	my_trade = gets.chomp.to_s.downcase
	
	if my_trade == 'y' || my_trade == 'yes'
		puts "what is your trade make? >> "
		trade_make = gets.chomp.to_s
		puts "what is it valued at? >> "
		value = gets.chomp.to_f
		puts "what is the reconditioning cost? >> "
		reconditioning = gets.chomp.to_f
		puts "what is the total licensing fee? >> "
		license_fee = gets.chomp.to_f
		puts "what is the total of any other misc. fee? >> "
		misc_fee = gets.chomp.to_f
		puts "what is the profit_obj? (**AS IT RELATES TO TRADE VEHICLE ONLY**) "
		profit_obj = gets.chomp.to_f
		my_trade_car = Trade.new(trade_make,sold,value, reconditioning, profit_obj, license_fee, misc_fee)
		my_trade_car.trade_markup
		my_trade_car.final_price_formatted
		my_trade_car.final_price
	end
	
	print "do you want to save this info? [y/n] "
	save_info = gets.chomp.to_s
	
	if save_info == 'y' || save_info == 'yes'
		if my_trade == 'y' || my_trade == 'yes'
			my_trade_car.trade_data
		else
			my_car.purchase_data
		end
	end
	
	puts "go again? [y/n] "
	restart = gets.chomp.to_s.downcase
	
	if restart == 'y' || restart =='yes'
		next
	end
	puts "goodbye"
	go = false
end
