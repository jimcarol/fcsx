#encoding:utf-8

require "active_record"
require "erb"
require_relative "./config/database.rb"

dirname = File.dirname(__FILE__)
Dir.glob(File.join(dirname, "models", "*.rb")) { |f| require f }
Dir.glob(File.join(dirname, "libs", "*.rb")) { |f| require f }

class Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    content = nil

    if (env["PATH_INFO"] === "/data")
      message = Message.all.to_json
      status  = 200
      headers = { "Content-Type" => "application/json;charset=utf-8" }
      body    = [message]

      content = [status, headers, body ]
    elsif (env["PATH_INFO"] === "/styles.css")
      status = 200
      headers = { "Content-Type" => "text/css" }
      body = [File.read("./views/styles.css")]

      content = [status, headers, body ]
    else
      data = {}
      types = Message.select(:type).distinct.map{|i| i.type }
      
      types.each do |type|
        data[type] = type.constantize.select([:id, :type, :title, :url, "cast(order_num as SIGNED) as order_num"]).order("order_num")
      end

      types << "tieba"

      if env["PATH_INFO"] === "/BaiduTOP10" || env["PATH_INFO"] === "/"
        selected = "BaiduTOP10"
        data.delete("Zhibo8TOP10")
      elsif env["PATH_INFO"] === "/Zhibo8TOP10"
        selected = "Zhibo8TOP10"
        data.delete("BaiduTOP10")
      elsif env["PATH_INFO"] === "/tieba"
        selected = "tieba"
        tieba_data = Tieba.limit(100).select([:id, :url, :title, :author, :author_link])
        data = { "tieba" => tieba_data }
      end

      content = ['200', {'Content-Type' => 'text/html'}, [RenderTemplate.new(types, data, selected).render()] ]
    end

    @app.call(env, content)
  end
end

app = Proc.new do|env, message|
  message
end

use Middleware
run app