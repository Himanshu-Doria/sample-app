class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		#request stores the url of the referrer too
		# return to the previous view or if there is no previous view, return to home page of user
		redirect_to request.referrer || root_url  
	end

	private

	def micropost_params
		params.require(:micropost).permit(:content)
	end

	def correct_user
		# checks whether the user really has the following micropost associated with him
		# by this user can only delete his own microposts
		@micropost = current_user.microposts.find_by(id: params[:id])
		#redirects if the micropost is not user's
		redirect_to root_url if @micropost.nil?
	end
end
