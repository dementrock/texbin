class Gist < ActiveRecord::Base
  validates :content, :presence => true
  attr_accessible :content, :key
  def to_param
    key
  end
  def image_finished?
    status = (image_status == 'finished')
    exists = FileTest.exists?(APP_CONFIG['image']['directory'] + "#{key}.jpg")
    if status and not exists
      self.image_status = 'wait'
      self.save
    end
    return (status and exists)
  end
end
