class User < ActiveRecord::Base
	attr_accessor :remember_token
	before_save {email.downcase!}
	validates :name, presence: true,length: {maximum: 50} 
	VALID_EMAIL_REGEX  = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true,
				length: {maximum: 255},format: {with: VALID_EMAIL_REGEX},
				uniqueness: { case_sensitive: false }
	has_secure_password

	#the pasword can be left blank in case of editing the user, however this would not be happening in case of signing up where
	# has_secure_password enforces the presence validation upon object creation
	validates :password, length: {minimum: 8}, allow_blank: true


	# the below defination is an example of defining a class method, by the help of 
	# singleton class defination. Following code is analogous to the defination that we provide while
	# defining the singleton class of an object, where the methods in that (meta)class are accessible to 
	# to that particular object only. The following code is analogous to that condition except instead of accessiblity to that object, they are accessible to
	# the Class itself. These are the Class methods and their functionality is similar to other methods of definining like self.method_name or Class_name.method_name
	class << self 
		#returns the hash digest of the given string
		def digest(string)
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
			BCrypt::Password.create(string, cost: cost)
		end
		# Returns a random remember me token
		def new_token
			SecureRandom.urlsafe_base64
		end
	end
	# remebers a user in the database for the use in persistent sessions
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end
	#forgets the user
	def forget
		update_attribute(:remember_digest, nil)
	end
	#Returns true id the given token matches the digest
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
end
