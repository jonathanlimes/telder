class Note < ApplicationRecord

  belongs_to :creator, class_name: "User", optional:true
  has_and_belongs_to_many :users

  validates :text, presence: true

  acts_as_taggable_on :tags

end
