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

def parse!(url:)
  # TODO: improve validation, maybe https://github.com/amogil/url_regex
  if URI.regexp =~ url
    return URI.parse(url)
  else
    open("#{url.host.to_s}.html", "w+") do |file|
      file.write("The url ('#{url}') provided is not valid")
    end
  end
end

def download(url:)
  open("#{url.host.to_s}.html", "w+") do |file|
    url.open do |html|
      file.write(html.read)
    end
  end
rescue SocketError => e
  open("#{url.host.to_s}.html", "w+") do |file|
    file.write("The url ('#{url}') provided is not valid")
  end
end

urls = []
ARGV.each do |arg|
  urls << parse!(url: arg)
end

urls.each do |url|
  download(url:)
end
