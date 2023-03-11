require 'open-uri'

class PageSnapshot < ApplicationRecord
  SNAPSHOT_SERVER = 'http://localhost:4000'

  belongs_to :user
  belongs_to :recipe

  def self.capture(url, user)
    create({ user: user }.merge(JSON.parse(URI.open(ENV.fetch('SAVEPAGE_SERVER') + '/?url=' + url).read)))
  end

  def live_html
    @live_html ||=Nokogiri::HTML(html)
  end
end
