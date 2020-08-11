class EmailAddress
  attr_accessor :kind, :email

  def to_s
    "#{kind}: #{email}"
  end  
end