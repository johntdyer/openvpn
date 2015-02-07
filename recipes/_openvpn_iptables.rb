
directory "/etc/openvpn/plugins" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/etc/openvpn/plugins/openvpn-iptables.py" do
  owner "root"
  group "root"
  mode 0777
  variables(
    prefix: 'vpn-'
  )
end

# knife data bag edit vpn users
tropo_team = Chef::DataBagItem.load("vpn","users")["tropo-employees"]

## Add users
tropo_team.each do |u|
  user "vpn-#{u}" do
    home "/dev/null"
    shell "/sbin/nologin"
    system true
  end
end


#### Start Apcera


# knife data bag edit vpn users
apcera_team = Chef::DataBagItem.load("vpn","users")["apcera-employees"]

## Add users
apcera_team.each do |u|
  user "vpn-#{u}" do
    home "/dev/null"
    shell "/sbin/nologin"
    system true
  end
end

template "/etc/openvpn/filter_groups.json" do
  source "filter_groups.json.erb"
  owner 'root'
  group 'root'
  mode 0644
  helpers(OpenVpnRouteToIptables)
  variables(
    routes: node[:openvpn][:routes]
  )
end

# add users to groups
group "tropo-operations" do
  members Chef::DataBagItem.load("vpn","users")["tropo-operations"]
end
group "vpn-employees" do
  members tropo_team.collect{|x| "vpn-#{x}"}
end

group "vpn-apcera" do
  members apcera_team.collect{|x| "vpn-#{x}"}
end
