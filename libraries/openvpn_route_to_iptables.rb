
module OpenVpnRouteToIptables
  require 'json'
  def route_to_cidr(address, mask, comment)
    m = mask.split(".").map { |e| e.to_i.to_s(2).rjust(8, "0") }.join.count("1").to_s
    "#{address}/#{m}"
  end

  def to_rule(rule)
    addr = route_to_cidr(rule[:address], rule[:mask], rule[:comment])
    {
      dst_ip: addr,
      comment: rule[:comment]
    }
  end

  def merge_employee_rules_and_routes(routes)
    employee_rules = Chef::DataBagItem.load('vpn','employee-rules')['rules']

    routes.each do |r|
      employee_rules <<  to_rule(r)
    end

    return JSON.pretty_generate(employee_rules)
  end

  def get_vendor_rules(vendor_databag)
    v = Chef::DataBagItem.load('vpn',"#{vendor_databag}")["rules"]
    JSON.pretty_generate(v)
  end
end

# include OpenVpnRouteToIptables

# rules = {routes_new: [
#       { push_only: true, address: '10.7.133.121',    mask: '255.255.255.255',    comment: 'Aspect DMZ ORL'},
#       { push_only: true, address: '10.7.133.122',    mask: '255.255.255.254',    comment: 'Aspect DMZ ORL'},
#       { push_only: true, address: '10.7.133.124',    mask: '255.255.255.254',    comment: 'Aspect DMZ ORL'},
#       { push_only: true, address: '10.71.133.121',    mask: '255.255.255.255',    comment: 'Aspect DMZ LAS'},
#       { push_only: true, address: '10.71.133.122',    mask: '255.255.255.254',    comment: 'Aspect DMZ LAS'},
#       { push_only: true, address: '10.71.133.124',    mask: '255.255.255.254',    comment: 'Aspect DMZ LAS'},
#       { push_only: true, address: '10.108.198.64',   mask: '255.255.255.192',  comment: 'Softlayer WDC Internal' },
#       { push_only: true, address: '10.109.242.128',  mask: '255.255.255.192',  comment: 'Softlayer WDC Internal' },
#       { push_only: true, address: '207.38.126.24',   mask: '255.255.255.255',  comment: 'billwise'} ,
#       { push_only: true, address: '207.38.126.26',   mask: '255.255.255.255',  comment: 'billwise'} ,
#       { push_only: true, address: '24.126.169.35',   mask: '255.255.255.255',  comment: 'mackins'} ,
#       { push_only: true, address: '54.225.254.111',  mask: '255.255.255.255',  comment: 'aws162.voxeolabs.com'} ,
#       { push_only: true, address: '54.208.117.101',  mask: '255.255.255.255',  comment: 'graphite.int.tropo.com'} ,
#       { push_only: true, address: '54.208.78.211',   mask: '255.255.255.255',  comment: 'labs.evolution.voxeo.com'} ,
#       { push_only: true, address: '124.42.0.242',    mask: '255.255.255.255',  comment: 'Route Beijing Cisco traffic through VPN OPS-1789'} ,
#       { push_only: true, address: '107.170.7.159',   mask: '255.255.255.255',  comment: 'VNC/IRC Bouncer'} ,
#       { push_only: true, address: '107.20.176.54',   mask: '255.255.255.255',  comment: 'FMS'} ,
#       { push_only: true, address: '54.244.93.164',   mask: '255.255.255.255',  comment: 'FMS'} ,
#       { push_only: true, address: '172.16.2.238',    mask: '255.255.255.255',  comment: 'dns2-i.dmz.us-east-1.aws.tropo.com' },
#       { push_only: true, address: '172.16.1.91',     mask: '255.255.255.255',  comment: 'dns1-i.dmz.us-east-1.aws.tropo.com' },
#       { push_only: true, address: '172.16.1.232',    mask: '255.255.255.255',  comment: 'sip-proxy1-i.dmz.us-east-1.aws.tropo.com' },
#       { push_only: true, address: '172.16.2.234',    mask: '255.255.255.255',  comment: 'sip-proxy2-i.dmz.us-east-1.aws.tropo.com' },
#       { push_only: true, address: '198.11.251.11',   mask: '255.255.255.192',  comment: 'Softlayer FW1 WDC External' },
#       { push_only: true, address: '198.11.251.12',   mask: '255.255.255.192',  comment: 'Softlayer FW2 WDC External' },

#       { address: '128.121.22.129',  mask: '255.255.255.192',  comment: 'Last Pass Website' },
#       { address: '38.127.167.0',    mask: '255.255.255.192',  comment: 'Last Pass Website' },
#       { address: '96.255.24.82',    mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '96.255.24.83',    mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '96.255.24.84',    mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '96.255.24.85',    mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '209.40.97.64',    mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '97.107.129.121',  mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '50.116.54.142',   mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '78.46.90.175',    mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '178.63.57.100',   mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '144.76.186.67',   mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '144.76.186.68',   mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '144.76.186.69',   mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '79.143.178.218',  mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.178.140', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.190.153', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.185.248', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.166.202', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.165.183', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.167.204', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.187.236', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.189.82',  mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.183.132', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.168.226', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.177.148', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.179.178', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.180.162', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.181.153', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.182.146', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '192.241.163.235', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '205.201.131.175', mask: '255.255.255.255',  comment: 'Last Pass Website' },
#       { address: '54.241.244.48',   mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '54.215.19.76',    mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '50.18.112.17',    mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '54.241.35.46',    mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '54.241.250.33',   mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '54.241.23.146',   mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '184.169.157.63',  mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '54.215.1.150',    mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '54.241.3.227',    mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '54.241.247.41',   mask: '255.255.255.255',  comment: 'se aws eip - OPS-3291'} ,
#       { address: '50.16.244.122',   mask: '255.255.255.255',  comment: 'transcription.voxeolabs.com'} ,
#       { address: '54.236.237.247',  mask: '255.255.255.255',  comment: 'wordpress lb1a tropo sites'} ,
#       { address: '54.208.7.57',     mask: '255.255.255.255',  comment: 'wordpress lb1b tropo sites'} ,
#       { address: '107.21.19.234',   mask: '255.255.255.255',  comment: 'wordpress lb1a phono sites'} ,
#       { address: '54.208.7.56',     mask: '255.255.255.255',  comment: 'wordpress lb1b phono sites'} ,
#       { address: '54.236.218.219',  mask: '255.255.255.255',  comment: 'wordpress lb1a voxeolabs sites'} ,
#       { address: '54.208.7.55',     mask: '255.255.255.255',  comment: 'wordpress lb1b voxeolabs sites'} ,
#       { address: '107.21.233.197',  mask: '255.255.255.255',  comment: 'wp1 -- Wordpress'} ,
#       { address: '23.23.190.11',    mask: '255.255.255.255',  comment: 'wp2 -- Wordpress'} ,
#       { address: '193.234.218.79',  mask: '255.255.255.255',  comment: 'JORVAS Lab - OPS-1951'} ,
#       { address: '75.62.61.0',      mask: '255.255.255.0',    comment: 'AT&T'} ,
#       { address: '75.62.62.0',      mask: '255.255.255.0',    comment: 'AT&T'} ,
#       { address: '207.242.225.112', mask: '255.255.255.248',  comment: 'AT&T lab in Midtown NJ'} ,
#       { address: '192.166.192.93',  mask: '255.255.255.255',  comment: 'DT Prod'} ,
#       { address: '192.166.192.108', mask: '255.255.255.255',  comment: 'DT Production gw108'} ,
#       { address: '192.166.192.107', mask: '255.255.255.255',  comment: 'DT Production gw109'} ,
#       { address: '192.166.193.78',  mask: '255.255.255.255',  comment: 'DT Production gw108-int'} ,
#       { address: '192.166.193.79',  mask: '255.255.255.255',  comment: 'DT Production gw109-int'} ,
#       { address: '192.166.192.74',  mask: '255.255.255.255',  comment: 'DT tropo-private.developergarden.com'} ,
#       { address: '118.21.139.117',  mask: '255.255.255.255',  comment: 'NTT Labs server in Japan -- OPS-1339'} ,
#       { address: '54.251.177.176',  mask: '255.255.255.255',  comment: 'Globe gateway1 -- OPS-2137'} ,
#       { address: '54.251.186.109',  mask: '255.255.255.255',  comment: 'Globe gateway2 -- OPS-2137'} ,
#       { address: '54.251.188.179',  mask: '255.255.255.255',  comment: 'Globe runtime1 -- OPS-2137'} ,
#       { address: '54.251.191.218',  mask: '255.255.255.255',  comment: 'Globe runtime2 -- OPS-2137'} ,
#       { address: '54.251.190.178',  mask: '255.255.255.255',  comment: 'Globe manager1 -- OPS-2137'} ,
#       { address: '54.251.189.135',  mask: '255.255.255.255',  comment: 'Globe manager2 -- OPS-2137'}
#     ]
# }

# puts OpenVpnRouteToIptables.print_all_rules(rules)
