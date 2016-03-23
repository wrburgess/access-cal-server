class Calendar < ActiveRecord::Base
  validates :name, presence: true

  has_many :calendar_users
  has_many :users, through: :calendar_users

  scope :active, -> { where(archived: false, test: false) }
  scope :archived, -> { where(archived: true) }
  scope :test, -> { where(test: true) }
end
