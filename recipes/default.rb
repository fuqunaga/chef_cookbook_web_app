include_recipe "apache2"
web_app "web_app" do
  docroot "/vagrant/www"
  template "web_app.conf.erb"
  #server_name node[:fqdn]
  server_name "fukunaga.imas.swdev.jp"
  server_aliases ["web"]
end

package "libuuid-devel" do
	action :install
end

package "pcre-devel" do
	action :install
end

# for xhprof
package "graphviz" do
	action :install
end

%w(oauth APC uuid memcache xhprof).each do |pkg|
	php_pear pkg do
		action :install
	end
end

#php_pear "APC" do
#	action :install
#end
link "/vagrant/www/apc.php" do
	to "/usr/share/pear/apc.php"
end

#php_pear "uuid" do
#	action :install
#end
#
##php_pear "xdebug" do
##	action :install
##end
#
#php_pear "xhprof" do
#	action :install
#	preferred_state :beta
#end

service "memcached" do
  action :start
end

# for xhprof
directory "/vagrant/www/xhprof" do
	action :create
end
%w(xhprof_html xhprof_lib).each do |dir|
	link "/vagrant/www/xhprof/#{dir}" do
		to "/usr/share/pear/#{dir}"
	end
end

# create db
include_recipe "database::mysql"
mysql_connection_info = {
	:host => 'localhost',
	:username => 'root',
	:password => node['mysql']['server_root_password']
}
%w(IMAS_0 IMAS_1).each do |db|
	mysql_database db do
		connection mysql_connection_info
		action :create
	end
end
mysql_database_user 'dbuser' do
  connection mysql_connection_info
  privileges %w(INSERT UPDATE DELETE SELECT)
  password ''
  action :grant
end
