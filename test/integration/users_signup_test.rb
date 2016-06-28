require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
	end
	test "invalid signup information" do 
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, user: {
				name: "",
				email: "user@invalid",
				password: "foo",
				password_confrimation: "bar"
			}
		end
		assert_template 'users/new'
	end
	test "valid signup information" do
		get signup_path
		assert_difference 'User.count',1 do
			post users_path, user: {name: "Example User",
				email: "user@example.com", 
				password: "passwords", 
				password_confrimation: "passwords"}
		end
		# this statement asserts for delivery of only one message
		assert_equal 1, ActionMailer::Base.deliveries.size
		# assigns lets us access instance variables in the corresponding action. in this 
		# case , it is referring to the create action that is accessed in above code lines
		user = assigns(:user)
		assert_not user.activated?
		log_in_as(user)
		assert_not is_logged_in?
		get edit_account_activation_path("invalid token")
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email: 'wrong')
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?
		follow_redirect!
		assert_template 'users/show'
		assert is_logged_in?
	end			
end
