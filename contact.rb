require "./phone_number"
require "./address"

class Contact
  attr_accessor :first_name, :middle_name, :last_name, :phone_numbers, :addresses
  
  def initialize
    @phone_numbers = []
    @addresses = []
  end 
  
  def add_phone_number(kind, number)
    phone_number = PhoneNumber.new
    phone_number.kind = kind
    phone_number.number = number
    phone_numbers.push(phone_number)
  end
  
  def add_address(kind, street_1, street_2 = '', city, state, postal_code)
    address = Address.new
    address.kind = kind
    address.street_1 = street_1
    address.city = city
    address.state = state
    address.postal_code = postal_code
    addresses.push(address)
  end  
  
  def first_last
    "#{first_name} #{last_name}"
  end  
  
  def full_name
    full_name = "#{first_name} #{last_name}"
    if !@middle_name.nil?
      full_name = "#{first_name} #{middle_name.slice(0, 1)}. #{last_name}"
    end
      "#{full_name}"
   end
   
   def last_first
     last_first = "#{@last_name}, #{@first_name}"
     if !@middle_name.nil?
       last_first = "#{last_name}, #{first_name} #{middle_name.slice(0, 1)}."
     end  
     "#{last_first}"
   end  
   
   def to_s(format = 'full_name')
     case format
       when 'full_name'
        full_name
       when 'last_first'
        last_first
       when 'first'
        first_name
       when 'last'
        last_name
       else 
        first_last
      end
   end  

  def print_phone_numbers
    puts 'Phone Numbers:'
    phone_numbers.each { |number| puts number}
  end

  def print_address
    puts 'Addresses:'
     addresses.each { |address| puts address.to_s('short') }
  end  
  
end  

