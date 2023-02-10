# frozen_string_literal: true

# read file
# handle the linux command stuff
# dockerize it, make it executable with shell script https://stackoverflow.com/questions/61515104/how-to-convert-a-ruby-script-into-an-executable
# refactor & handle possible errors

# use nokogiri to get <a>, <img>, svg?
# store in metadata

# BONUS:
# store assets in "domain" namespaced folder, subfolders named css/images etc
# store assets in named volume in docker

# TODO: handle infinite scrolling pages, use selenium

require 'open-uri'

for arg in ARGV
  uri = URI.parse(arg)

  open("#{uri.host.to_s}.html", "w+") do |file|
    uri.open do |url|
      file.write(url.read)
    end
  end
end
