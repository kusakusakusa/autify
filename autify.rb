# frozen_string_literal: true

# read file
# handle the linux command stuff
# dockerize it, make it executable with shell script https://stackoverflow.com/questions/61515104/how-to-convert-a-ruby-script-into-an-executable
# refactor & handle possible errors

# use nokogiri to get <a>, <img>, svg?
# store last fetch date

# BONUS:
# store assets in "domain" namespaced folder, subfolders named css/images etc
# store assets in named volume in docker

# TODO: handle infinite scrolling pages, use selenium

require 'open-uri'
require 'nokogiri'
require 'timeout'
# require 'pry'

READ_TIMEOUT = 3

@output = {}

def host_of(url:)
  if url.is_a?(String)
    URI.parse(url)
  else
    url
  end.host.to_s
end

def last_crawl_filename(url:)
  "#{host_of(url:)}/last_crawled.txt"
end

def record_last_crawl(url:)
  open(last_crawl_filename(url:), 'w') do |file|
    file.write(Time.now.iso8601)
  end
end

def retrieve_last_crawl(url:)
  if File.exist?(last_crawl_filename(url:))
    open(last_crawl_filename(url:), 'r').read
  else
    'N/A'
  end
end

def handle_error(url:, msg: 'URL provided not valid')
  @output[url.to_s] = "site: #{url.to_s} (#{msg})"
end

def parse!(url:)
  # TODO: improve validation, maybe https://github.com/amogil/url_regex
  if URI.regexp =~ url
    return URI.parse(url)
  else
    handle_error(url:)
  end
end

def download(url:)
  Timeout.timeout(READ_TIMEOUT) do
    url.open(read_timeout: 10) do |html|
      content = html.read

      open("#{host_of(url:)}.html", "w+") do |file|
        file.write(content)
      end

      FileUtils.mkdir_p(host_of(url:))

      doc = Nokogiri::HTML(content)
      @output[url.to_s] = "site: #{url.to_s}\nnum_link: #{doc.css('a').size}\nimages: #{doc.css('img').size}\nlast_fetch: #{retrieve_last_crawl(url:)}"

      record_last_crawl(url:)
    end
  end
rescue URI::InvalidURIError
  handle_error(url:)
rescue Timeout::Error
  handle_error(url:, msg: 'URL timed out')
rescue SocketError
  handle_error(url:)
end

urls = []
ARGV.each do |arg|
  urls << parse!(url: arg)
end

threads = []
urls.each do |url|
  threads << Thread.new do
    download(url:)
  end
end

threads.each(&:join)

puts (urls.map do |url|
  @output[url.to_s]
end.join("\n\n"))
