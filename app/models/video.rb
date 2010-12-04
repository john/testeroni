# coding: utf-8

class Video < ActiveRecord::Base
  
  belongs_to :tst
  belongs_to :question
  
  validates :url, :presence => true
  
  def get_provider_id_from_url
    @providerid = nil
    if url =~ /youtube/
      pid = url.scan(/v=(.*)&*/)
      @providerid = (pid.blank? || pid[0].blank?) ? nil : pid[0][0]
    end
    @providerid
  end
  
end
