require "mysql"
require "yaml"
provides "mysql"

mysql Mash.new

slaves = []

mysql_config = YAML::load( File.open( '/etc/chef/mysql.yml') )

my = Mysql::new("localhost", mysql_config['user'], mysql_config['pass'], mysql_config['db'])
res = my.query("select host from information_schema.processlist where command = 'Binlog Dump'")
res.each do |row|
   slaves.push(row[0])
end
if slaves.size > 1
   mysql[:slaves] = slaves
end

rep_info = my.query("show slave status")
rep_info.each do |row|
   mysql[:master] =  row[1]
end
