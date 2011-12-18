class Gist < ActiveRecord::Base
  validates :content, :presence => true
  attr_accessible :content, :key
  def to_param
    key
  end
end
