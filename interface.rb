require 'active_record'
require './lib/product'
require './lib/cashier'
require './lib/sale'
require './lib/cart'
require 'pry'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to POS System"
  main_menu
end

def main_menu
  puts "Press 'a' to Add a new Product",
       "Press 'c' to Add a new Cashier",
       "Press 's' to Add a Sale",
       "Press 'd' for Sales per Dates",
       "Press 'e' to see a cashiers efficiency",
       "Press 'x' to exit"
  choice = gets.chomp.downcase

  case choice
  when 'a'
    add_product
  when 'c'
    add_cashier
  when 's'
    add_sale
  when 'd'
    sale_date
  when 'e'
    cashiers_date
  when 'x'
    puts "Goodbye!"
  else
    puts "Invalid input, please try again!"
    main_menu
  end
end

def add_product
  puts "What is the product's name?"
  product = gets.chomp
  puts "What is its price?"
  price = gets.chomp
  new_product = Product.new(:name => product, :price => price)
  new_product.save
  main_menu
end

def add_cashier
  puts "What is the Cashier's name?"
  cashier = gets.chomp
  new_cashier = Cashier.new(:name => cashier)
  new_cashier.save
  main_menu
end

def add_sale
  x = false
  puts "What is your name?"
  cashier = gets.chomp
  cashier = Cashier.where(:name => cashier).pop
  sale = Sale.new(:cashier_id => cashier.id, :total => [])
  sale.save
  until x == true
    puts "What is being purchased?"
    product = gets.chomp
    if product == 'end'
      x = true
    else
      product = Product.where(:name => product).pop
      puts "How many #{product.name}'s are being purchased?"
      quantity = gets.chomp.to_i
      new_cart = Cart.new(:product => product, :quantity => quantity, :sale => sale)
      new_cart.save
    end
  end
  cost_of_products = 0
  sale.carts.each do |cart|
    cost_of_products += cart.quantity * cart.product.price
  end
  puts "Your toal is: #{cost_of_products}"
  Sale.update(sale.id, :total => cost_of_products)
  sale.products.each { |product| puts "#{product.name}  $#{product.price}" }

  main_menu
end

def sale_date
  puts "Between what two dates do you want to see the sales for?"
  date = gets.chomp
  date = date.split(" and ")
  date_carts = Cart.where(:created_at => date[0]..date[1])
  cost_of_products = 0
  date_carts.each do |cart|
    cost_of_products += cart.quantity * cart.product.price
  end
  puts "Total Sales for date range is $#{cost_of_products}"
  main_menu
end

def cashiers_date
  puts "Between what two dates do you want to see the cashier's activity for?"
  date = gets.chomp
  date = date.split(" and ")
  puts "And which cashier are you inquiring into?"
  cashier = gets.chomp
  cashier = Cashier.where(:name => cashier).pop
  date_cashiers = Sale.where(:created_at => date[0]..date[1], :cashier_id => cashier.id)
  puts "Total Sales for #{cashier.name} is #{date_cashiers.length}"
  main_menu
end





welcome
