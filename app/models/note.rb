class Note < ApplicationRecord

  belongs_to :creator, class_name: "User", optional:true
  has_and_belongs_to_many :users

  validates :text, presence: true

  acts_as_taggable_on :tags

  before_create :generate_random_id

  private

  def generate_random_id
    begin
      self.id = SecureRandom.random_number(10000000)
    end while Note.where(id: self.id).exists?
  end

end
