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
       "Press 'r' to See the receipt"
       "Press 'x' to exit"
  choice = gets.chomp.downcase

  case choice
  when 'a'
    add_product
  when 'c'
    add_cashier
  when 's'
    add_sale
  when 'r'
    see_receipt
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
  total = []
  q = []
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
  sale.products.each { |product| total << product.price.to_f }
  Cart.where(:sale_id =>sale).each { |i| q << i.quantity }
  receipt = []
  i = 0
  until i == total.length
    receipt << total[i] * q[i]
    i += 1
  end
  binding.pry
  puts receipt.reduce(:+)



  # in carts where sale = sale.id get price for product and times by qunatity

  # price = new_cart.product.price
  # puts "Your total is: $#{price}."

  main_menu
end




welcome
