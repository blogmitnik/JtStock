class Station < ActiveRecord::Base
  attr_accessible :post_id, :yield_file_id, :name

  belongs_to :post
  belongs_to :yield_file
  has_many :reports, dependent: :destroy
  has_many :mi_reports, dependent: :destroy

  validates :name, :post_id, :yield_file_id, presence: true
end
