class Post < ActiveRecord::Base
  attr_accessible :title, :current_year, :current_month, :current_date

  has_many :reports, dependent: :destroy
  has_many :yield_files, dependent: :destroy
  has_many :stations, dependent: :destroy

  validates :title, presence: true, length: { :minimum => 3, :maximum => 255 }

end
