require "./contact.rb"
require "yaml"	#a library that enables yml files to be used in ruby programs

class AddressBook

	attr_reader :contacts

	def initialize
		@contacts = []
		open()		#Opens a new file once a new class object is created. anything saved will be loaded into the contacts array
	end

	def open
		if File.exists?("contacts.yml")		#tests whether there is a specified yml file available
			@contacts = YAML.load_file("contacts.yml")	#replaces the contacts array with the contents of the yml file. The contents of the file are parsed back into a ruby object and replace what is in the contacts array. This keeps the contacts list up to date with the latesst changes. 
		end
	end

	def save 		#this will save the contents of the contacts array into a text based yml file
		File.open("contacts.yml", "w") do |file|		#Opens the contacts.yml file in the writing("w") mode. The file requires yaml to load (specify at the top like a ruby file)
			file.write(contacts.to_yaml)				#The contents of the contacts array are written into the file specified above. The object is written into the file each time the method runs.
		end
	end

	def run				#when called, it gives the user options for interacting with the program
		loop  do 			#The loop will iterate each time an option is selected until "e" is selected and the loop is broken. The options will pop up each time after an option is selected and ran unless the user selects "e"
			puts "Address Book"
			puts "a: Add a contact"
			puts "d: Delete a contact"
			puts "p: Print contact list"
			puts "s: Search"
			puts "e: Exit"
			print "Enter your choice: "
			input = gets.chomp.downcase
			case input
			when "p"
				print_contact_list
			when "s"
				puts "Enter your search term: "
				search = gets.chomp
				find_by_name(search)
				find_by_address(search)
				find_by_phone_number(search)
			when "a"
				add_contact
			when "d"
				delete_contact
			when "e"
				save()		#saves the results before exiting the program
				break
			end
		end
	end

	def delete_contact
		puts "Please enter the name of the contact you want deleted: "
		query = gets.downcase
		contacts.each do |contact|
			if contact.full_name.include?(query)
				puts "Are you sure you want to delete #{query}? y/n"
				answer = gets.chomp.downcase
					if answer == "y"
						index = contacts.contact.index(query)
						contacts.delete_at(index)
						print_contact_list
				else
					break
				end
			end
		end
	end

	def add_contact
  		contact = Contact.new
  		print "First name: "
  		contact.first_name = gets.chomp
  		print "Middle name: "
  		contact.middle_name = gets.chomp
  		print "Last name: "
  		contact.last_name = gets.chomp

  		loop do 	#Loops are used with a set of options that need to be presented multiple times
    		puts "Add phone number or address? "
    		puts "p: Add phone number"
    		puts "a: Add address"
    		puts "(Any other key to go back)"
    		response = gets.chomp.downcase
    		case response
    		when 'p'
		      phone = PhoneNumber.new
		      print "Phone number kind (Home, Work, etc): "
		      phone.kind = gets.chomp
		      print "Number: "
		      phone.number = gets.chomp
		      contact.phone_numbers.push(phone)
    		when 'a'
		      address = Address.new
		      print "Address Kind (Home, Work, etc): "
		      address.kind = gets.chomp
		      print "Address line 1: "
		      address.street_1 = gets.chomp
		      print "Address line 2: "
		      address.street_2 = gets.chomp
		      print "City: "
		      address.city = gets.chomp
		      print "State: "
		      address.state = gets.chomp
		      print "Postal Code: "
		      address.postal_code = gets.chomp
		      contact.addresses.push(address)
		    else
		      print "\n"
		      break
		    end
		end
		  contacts.push(contact)
	end


	def find_by_name(name)
		results = []
		search = name.downcase							#search equal the name passed in as an argument into the method. In other words it equals the name we are searching for.
		contacts.each do |contact|
			if contact.full_name.downcase.include?(search)		#if the full name of the contact includes the argument put in, push the matching contact(s) into the results array. The include?() method determines whether an object contains a particular argument 
				results.push(contact)
			end
		end
		print_results("Name search results for '#{name}'", results)
	end

	def find_by_phone_number(number)
		results = []
		search = number.gsub("-", "")			#the gsub method replaces a character in the object with another 				
		contacts.each do |contact|
			contact.phone_numbers.each do |phone_number|
				if phone_number.number.gsub("-","").include?(search)
				results.push(contact)			#push the contact instead of the "phone_number" because each contact has access to various print methods
				end
			end
		end
		print_results("Phone search results for '#{search}'", results)
	end

	def find_by_address(address)
		results = []
		search = address.downcase							
		contacts.each do |contact|
			contact.addresses.each do |address|
				if address.street_1.include?(search) || address.street_2.include?(search)	#if the argument matches either the first or second addresses, push the contact into the results array
				results.push(contact) unless results.include?(contact)					#pushes the contact into the results array unless that contact is already in there
				end
			end
		end
		print_results("Address search results for '#{search}'", results)
	end

	def print_results(search, results)		#prints the description of the results and the second argument takes the results array, which is then looped through
		puts search
		puts "\n"
		results.each do |contact|
			puts "----------------------------------"
			puts contact.to_s("full_name")
			puts "\n"
			contact.print_phone_numbers
			puts "\n"
			contact.print_addresses
			puts "\n"
		end
	end

	def print_contact_list
		puts "\n"
		puts "Contact List:"
		puts "-----------------"
		contacts.each do |contact|
			puts contact.to_s("last_first")
		end
		puts "\n"
	end

end

address_book = AddressBook.new
address_book.run	#calls the run method, which displays the menu for the user

