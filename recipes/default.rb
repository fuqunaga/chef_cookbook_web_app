include_recipe "apache2"
web_app "web_app" do
  docroot "/vagrant/www"
  template "web_app.conf.erb"
  #server_name node[:fqdn]
  server_name "fukunaga.imas.swdev.jp"
  server_aliases ["web"]
end

package "pcre-devel" do
	action :install
end

php_pear "oauth" do
	action :install
end

php_pear "APC" do
	action :install
end
