class ChefDnsZone
  class Provider
    class Zonefile < Chef::Provider
      provides :dns_zone_zonefile, os: "linux"

      def load_current_resource
        @current_resource = ChefDnsZone::Resource::Zonefile.new(new_resource.name)
        current_resource
      end

      def action_create
        create_path
        zonefile.run_action(:create)
        new_resource.updated_by_last_action(zonefile.updated_by_last_action?)
      end

      def action_create_if_missing
        create_path
        zonefile.run_action(:create_if_missing)
        new_resource.updated_by_last_action(zonefile.updated_by_last_action?)
      end

      private

      def create_path
        Chef::Resource::Directory.new(::File.dirname(new_resource.path), run_context).tap do |r|
          r.recursive true
        end.run_action(:create_if_missing)
      end

      def zonefile
        @zonefile ||= Chef::Resource::File.new(new_resource.path, run_context).tap do |r|
          r.path new_resource.path
          r.content new_resource.config
          r.owner new_resource.owner
          r.group new_resource.group
          # r.atomic_update false
        end
      end
    end
  end
end
