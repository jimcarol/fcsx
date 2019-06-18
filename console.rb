require "irb"
require "active_record"
require_relative "./config/database.rb"

dirname = File.dirname(__FILE__)
Dir.glob(File.join(dirname, "models", "*.rb")) { |f| require f }


IRB.start