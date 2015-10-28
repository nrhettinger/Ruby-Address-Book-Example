class Address

	attr_accessor :kind, :street_1, :street_2, :city, :state, :postal_code

	def to_s(format="short")
		address = ""
		case format
		when "short"
			address += "#{kind}: "
			address += street_1
			if street_2						#if there is a street_2 specified, put it in the address
				address += ", #{street_2}"
			end
			address += ", #{city}, #{state}, #{postal_code}"
		when "long"
			address += "#{street_1} \n"
			if street_2
				address += "#{street_2} \n"
			end
			address += "#{city}, #{state}, #{postal_code}"
		end
		address
	end
		
end

home = Address.new
home.kind = "Home"
home.street_1 = "6300 Running Oak Dr."
home.street_2 = "8922 3rd Avenue"
home.city = "Redwood"
home.state = "CT"
home.postal_code = "93552"

#puts home.to_s("short")
puts "\n"
#puts home.to_s("long")