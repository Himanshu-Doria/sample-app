class Micropost < ActiveRecord::Base
  belongs_to :user
  #sets the default order in which the elements are retrived from the database
  #in this case , in the most recent(descending order)
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  #used to associated this model with the image given by PictueUploader
  mount_uploader :picture, PictureUploader
  validate :picture_size

  private
  #Validates the size of an uploaded picture.
  # server side validation
  def picture_size
  	if picture.size > 5.megabytes
  		errors.add(:picture, "should be less than 5MB") #append the error statement to error statement array
  	end
  end
end
