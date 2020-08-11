require './contact.rb'
require 'yaml'
# need to add validation
class AddressBook
  attr_reader :contacts
  
  def initialize
    @contacts = []
    open()
  end 

  def open
    if File.exists?('contacts.yml')
      @contacts = YAML.load_file('contacts.yml')
    end
  end

  def save
    # arguments ('name of file', 'mode you want(write, read, etc)')
    File.open('contacts.yml', 'w') do |file|
      file.write(contacts.to_yaml)
    end
  end
  
  def add_contact
    contact = Contact.new
    print 'First Name: '
    contact.first_name = gets.chomp
    print 'Middle Name: '
    contact.middle_name = gets.chomp
    print 'Last Name: '
    contact.last_name = gets.chomp
    contacts.push(contact)
    
    loop do
      puts "\n"
      puts "Add phone number or address?"
      puts 'p: Add phone number'
      puts 'ad: Add address'
      puts 'em: Add email address'
      puts 'Press any other key to go back'
      response = gets.chomp.downcase
      kind_enum = ['home', 'office', 'work']
      case response
      when 'p'
        print 'Phone number kind? (home, work, office): '
        phone_kind = gets.chomp.downcase
        # loops until correct kind is entered
      loop do
        if kind_enum.one?(phone_kind)
          break
        else 
          puts "The kind #{phone_kind} isn't allowed \n"
          print 'Phone number kind? (home, work, office): '
          phone_kind = gets.chomp.downcase
        end  
      end
        print 'Enter a phone number (###-###-###): '
        phone_number = gets.chomp
        loop do
          if phone_number.match?(/((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}/)
            break
          else
            puts 'Phone number does not match the (###-###-###) format'
            print 'Enter a phone number: '
            phone_number = gets.chomp
          end
        end
        contact.add_phone_number(phone_kind, phone_number)
      when 'ad'
        print 'Address kind? (Home, Work, etc.): '
        address_kind = gets.chomp.downcase
        print 'Address line 1: '
        street_1 = gets.chomp.downcase
        print 'Do you have an address line 2? (y/n): '
        response = gets.chomp.downcase
        case response
        when 'y' || 'yes'
          print 'Address line 2: '
          street_2 = gets.chomp.downcase
        when 'n' || 'no'
          street_2 = ''
        end
        print 'City: '
        city = gets.chomp.downcase
        print 'State: '
        state = gets.chomp.downcase
        print 'Postal/Zip Code: '
        postal_code = gets.chomp
        contact.add_address(address_kind, street_1, street_2, city, state, postal_code )
      when 'em'
         print 'email kind? (home, work, office): '
        email_kind = gets.chomp.downcase
        # loops until correct kind is entered
      loop do
        if kind_enum.one?(email_kind)
          break
        else 
          puts "The kind #{email_kind} isn't allowed \n"
          print 'email kind? (home, work, office): '
          email_kind = gets.chomp.downcase
        end  
      end
        print 'Enter an email address (example@email.com): '
        email_address = gets.chomp.downcase
        loop do
          if email_address.match?(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/)
            break
          else
            puts 'Email address does not match the (example@email.com) format \n'
            print 'Enter an email address (example@email.com): '
            email_address = gets.chomp
          end
        end
        contact.add_email_address(email_kind, email_address)
      else 
        print "\n"
        break
      end
    end
  end  

  def search_contacts
    puts "\n"
    loop do
      puts 'How would you like to search?'
      puts 'p: Phone number'
      puts 'n: Name'
      puts 'a: Address'
      puts 'Press any other key to go back'
      puts "\n"
      print 'Enter your choice: '
      response = gets.chomp.downcase
      case response
      when 'p'
        print 'Enter a phone number: '
        number = gets.chomp.gsub('-', '')
        find_by_phone_number(number)
      when 'n'
        print 'Enter a Name: '
        name = gets.chomp.downcase
        find_by_name(name)
      when 'a'
        print 'Enter an Address: '
        address = gets.chomp.downcase
        find_by_address(address)
      else 
        puts "\n"
        break
      end

    end
  end 

  def remove_contact
    loop do
    print "What's the first name of the contact you would like to remove? "
    person = gets.chomp
    selected_contact = contacts.select { |contact| contact.first_name == person }
    selected_contact.each do |contact| 
    print "Are you sure you would like to delete contact: #{contact.full_name}? This action is irreversable (y/n) "
    end

    input = gets.chomp.downcase
    case input
      when 'y' || 'yes'
        contacts.delete_if { |contact| contact.first_name == person }
        break
      when 'n' || 'no'
        print 'Contact not deleted'
        print "\n"
        break
      end
    end  
  end

  def edit_contact
    # finish the edit contact method
  end
  
  def run 
    loop do 
      puts "Address Book Menu:"
      puts "\n"
      puts "p: Print address book"
      puts 'a: Add new contact'
      puts 's: Search for a contact'
      puts 'r: Remove contact'
      puts 'e: Exit address book'
      puts "\n"
      print 'Enter your choice: '
      input = gets.chomp.downcase
      puts "\n"
      case input
        when 'p'
          print_contacts
        when 'a'
          add_contact
        when 's'
          search_contacts
        when 'r'
          remove_contact
        when 'e'
          save()
          break
      end
      puts "\n" * 4 
     end 
    
  end  
  
  def print_results(message, results)
    print_line
     puts message
    print_line
      results.each do |contact| 
        puts contact.to_s('full_name')
        contact.print_phone_numbers
        contact.print_address
        contact.print_email
        puts "\n"
       end  
    print_line   
  end  

  def print_line
    puts '-' * 40
  end
  
  def find_by_phone_number(number)
    results = []
    search = number.gsub('-', '')
    contacts.each do |contact| 
      contact.phone_numbers.each do |phone_number|
        if phone_number.number.gsub('-', '').include?(search)
            results.push(contact) unless results.include?(contact)
        end
      end  
    end
    print_results("Phone number search results for (#{search})", results)
  end  
  
  def find_by_address(query)
    results = []
    search = query.downcase
    contacts.each do |contact|
      contact.addresses.each do |address|
        if address.to_s('long').include?(search)
          results.push(contact) unless results.include?(contact)
        end  
      end
    end 
      print_results("Address search results for #{search}", results)
    end  
  
  def find_by_name(name)
    results = []
    search = name.downcase
    contacts.each do |contact|
      if contact.full_name.downcase.include?(search)
        results.push(contact) unless results.include?(contact)
       end
    end 
   print_results("Name search results for (#{search})", results)
  end  

  def find_by_email
    #complete find by email method
  end
 
  
  def print_contacts
    puts "Contact List:"
    contacts.each do |contact|
      puts contact.to_s('last_first')
    end  
  end  
  
end  


address_book = AddressBook.new
address_book.run