class Micropost < ActiveRecord::Base
  belongs_to :user
  #sets the default order in which the elements are retrived from the database
  #in this case , in the most recent(descending order)
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
