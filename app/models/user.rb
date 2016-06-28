class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token
	before_save :downcase_email
	before_create :create_activation_digest
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
	#checks for the user activation
	def activated?
		self.activated
	end
	#Returns true id the given token matches the digest
	# we have now used the metaprogramming method , in which we would use the send method of the User object to explicitly called the 
	# required method , whose name can be passed as argument to the this method, a form of function overloading
	def authenticated?(attribute, token)
		digest =  self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

		#Activates an account
	def activate
		update_attribute(:activated, true)
		update_attribute(:activated_at, Time.zone.now)
	end

	#Sends an activation email
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end
	private 

	def downcase_email
		self.email = email.downcase
	end

	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end
end
