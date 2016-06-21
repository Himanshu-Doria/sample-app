module ApplicationHelper
#A helper is ruby file which contains user_defined methods used for particular controller and views of that controller
#the application helper is global for the application and can used by any view and controller

	#This method returns the title of the page
	def full_title(page_title = '')
		base_title  = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end
end
