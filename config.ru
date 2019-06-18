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
      headers = { "Content-Type" => "application/json" }
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

      content = ['200', {'Content-Type' => 'text/html'}, [RenderTemplate.new(types, data).render()] ]
    end

    @app.call(env, content)
  end
end

app = Proc.new do|env, message|
  message
end

use Middleware
run app