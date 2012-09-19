install = (node[:phantomjs][:action] == "install")

if defined?(Chef::Extensions)
  wan_up = Chef::Extensions.wan_up?
else
  # Should be part of Chef really...
  # grab it here https://github.com/gchef/chef-extensions
  wan_up = "unknown"
end

if install
  remote_file "#{node[:phantomjs][:srcdir]}/#{node[:phantomjs][:source_file]}" do
    source node[:phantomjs][:source]
    action :create_if_missing
    only_if { wan_up }
  end

  bash "Installing phantomjs from binary" do
    cwd node[:phantomjs][:srcdir]
    code %{
      if [[ -e #{node[:phantomjs][:source_file]} ]] && [[ ! -d #{node[:phantomjs][:dir]} ]]
      then
        tar -xjvf #{node[:phantomjs][:source_file]} &&
        ln -nfs #{node[:phantomjs][:srcdir]}/#{node[:phantomjs][:dir]}/bin/phantomjs #{node[:phantomjs][:bindir]}/phantomjs
      fi
    }
  end

else
  directory "#{node[:phantomjs][:srcdir]}/#{node[:phantomjs][:dir]}" do
    recursive true
    action :delete
  end

  file "#{node[:phantomjs][:srcdir]}/#{node[:phantomjs][:source_file]}" do
    action :delete
  end

  link "#{node[:phantomjs][:bindir]}/phantomjs" do
    action :delete
  end
end
