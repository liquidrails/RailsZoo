class Administrator < ActiveRecord::Base


validates_presence_of  :name
validates_uniqueness_of  :name
validates_confirmation_of  :password

attr_reader  :password

def password=(pw)
  @password = pw # used by confirmation validator
  salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp # 2^28 combos
  self.password_salt = salt
  self.password_hash = Digest::MD5.hexdigest(pw + salt)
end

  def password_is?(pw)
    Digest::MD5.hexdigest(pw + password_salt) == password_hash
  end


end
