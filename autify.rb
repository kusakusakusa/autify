# frozen_string_literal: true

# read file
# handle the linux command stuff
# dockerize it

# use nokogiri to get <a>, <img>, svg?
# store in metadata

# BONUS:
# store assets in "domain" namespaced folder, subfolders named css/images etc
# store assets in named volume in docker

# TODO: handle infinite scrolling pages, use selenium

require 'open-uri'

uri = URI.parse('https://autify.com/pricing')

open("#{uri.host.to_s}.html", "w+") do |file|
  uri.open do |url|
    file.write(url.read)
  end
end
