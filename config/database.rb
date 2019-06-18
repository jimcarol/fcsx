ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  host:     ENV["DB_HOST"] || 'localhost',
  username: 'root',
  password: '123456',
  database: 'news'
)