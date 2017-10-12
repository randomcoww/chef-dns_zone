class ChefDnsZone
  class Resource
    class Zonefile < Chef::Resource
      resource_name :dns_zone_zonefile

      default_action :create
      allowed_actions :create, :create_if_missing

      property :owner, String
      property :group, String
      property :zone_hash, Hash
      property :config, default: lazy { DnsZoneHelper::ConfigGenerator.generate_from_hash(zone_hash).join($/) }
      property :path, String
    end
  end
end
