class Note < ApplicationRecord

  belongs_to :creator, class_name: "User"
  has_and_belongs_to_many :users

  acts_as_taggable_on :tags

end