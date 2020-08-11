class Address
  attr_accessor :kind, :street_1, :street_2, :city, :state, :postal_code
  
  def long_address
    address = ''
    address += "#{street_1}., \n"
    address += "#{street_2} \n" if !street_2.nil?
    address += "#{city}, #{state} #{postal_code}"
    address
  end

  def short_address
    address = ''
    address = "#{kind}: #{street_1}., #{city}, #{state} #{postal_code}"
      if street_2
         address = "#{kind}: #{street_1} #{street_2}., #{city}, #{state} #{postal_code}"
       end
     address
  end  
  
  def to_s(format = 'short')
    case format
      when 'long'
        long_address
      when 'short'
        short_address
     end  
  end  
  
end

