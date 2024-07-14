require "net/http"
require "uri"
require "json"

URL = ENV["MY_SLACK_CHANNEL_WEBHOOK"]

def send_to_slack(message)
  uri = URI.parse("#{URL}")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request.body = JSON.dump({text: "#{message}" })

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  code = response.code
  unless code == "200"
    # エラーの時だけエラーを表示する
    STDERR.print "Error!\n#{response.body}\n"
  end
end

send_to_slack(ARGV[0])