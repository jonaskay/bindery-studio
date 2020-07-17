class Site < ApplicationRecord
  BASE_URL = "https://storage.googleapis.com/"

  belongs_to :publication

  validates :name, presence: true
  validates :bucket, presence: true

  def url
    "#{BASE_URL}#{bucket}/#{name}/index.html"
  end
end
