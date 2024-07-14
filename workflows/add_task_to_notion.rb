require "net/http"
require "uri"
require "json"
require "date"

MY_NOTION_TOKEN=ENV["TOKEN"]
DATABASE_ID=ENV["DATABASE_ID"]
TZ="+09:00"

def send_notion(title)
  uri = URI.parse("https://api.notion.com/v1/pages")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request["Authorization"] = "Bearer #{MY_NOTION_TOKEN}"
  request["Notion-Version"] = "2022-06-28"
  request.body = JSON.dump({
    "parent" => {
      "database_id" => "#{DATABASE_ID}"
    },
    "properties" => {
      "Name" => {
        "title" => [
          {
            "text" => {
              "content" => "#{title}"
            }
          }
        ]
      }
    }
  })

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  code = response.code
  # print "#{title}\t#{datetime}...#{code}\n"
  unless code == "200"
    # エラーの時だけエラーを表示する
    STDERR.print "Error!\n#{response.body}\n"
  end
end

send_notion(ARGV[0])