
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
