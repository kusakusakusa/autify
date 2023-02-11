# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'timeout'
# require 'pry'

READ_TIMEOUT = 3
THREADS_SIZE = 10

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

def tally_stats(content:, url:)
  doc = Nokogiri::HTML(content)
  @output[url.to_s] = "site: #{url.to_s}\nnum_link: #{doc.css('a').size}\nimages: #{doc.css('img').size}\nlast_fetch: #{retrieve_last_crawl(url:)}"
end

def handle_error(url:, msg: 'URL provided not valid')
  @output[url.to_s] = "site: #{url.to_s} (#{msg})"
end

def parse!(url:)
  if URI.regexp =~ url
    return URI.parse(url)
  else
    handle_error(url:)
  end
end

def download(url:)
  Timeout.timeout(READ_TIMEOUT) do
    parse!(url:).open do |html|
      content = html.read

      open("#{host_of(url:)}.html", "w+") do |file|
        file.write(content)
      end

      FileUtils.mkdir_p(host_of(url:))

      tally_stats(content:, url:)

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

ARGV.each_slice(THREADS_SIZE) do |batch|
  threads = []
  batch.each do |_url|
    threads << Thread.new(_url) do |url|
      download(url:)
    end
  end

  threads.each(&:join)
end

puts (ARGV.map do |url|
  @output[url.to_s]
end.join("\n\n"))
