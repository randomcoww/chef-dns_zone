module DnsZoneHelper

  # {
  #   'soa' => {
  #     name: 'name',
  #     ttl: 300,
  #     ns: 'ns.test.local.',
  #     email: 'root.test.local.',
  #     sn: 10000001,
  #     ref: 1000,
  #     ret: 1000,
  #     ex: 1000,
  #     nx: 1000
  #   },
  #   'ns' => {
  #     name: 'ns',
  #     ttl: 300,
  #     host: 'ns.test.local'
  #   },
  #   'a' => [
  #     {
  #       name: 'host1',
  #       ttl: 300,
  #       host: 'host1.test.local'
  #     },
  #     {
  #       name: 'host2',
  #       ttl: 300,
  #       host: 'host2.test.local'
  #     }
  #   ]
  # }

  class ConfigGenerator

    MAP = {
      "soa" => [
        :name, :ttl, :type, :ns, :email, :sn, :ref, :ret, :ex, :nx
      ],
      "ns" => [
        :name, :ttl, :type, :host
      ],
      "a" => [
        :name, :ttl, :type, :host
      ],
      "cname" => [
        :name, :ttl, :type, :host
      ],
      "srv" => [
        :name, :ttl, :type, :priority, :weight, :port, :host
      ]
    }

    def self.generate_from_hash(c)
      g = new
      records = []

      MAP.each do |type, m|

        if c.has_key?(type)
          g.add_record(records, type, m, c[type])
        end
      end

      records.join($/)
    end

    def add_record(records, type, m, c)
      case c
      when Array
        c.each do |a|
          add_record(records, type, m, a)
        end

      when Hash
        c[:type] = type.upcase

        record = []
        m.each do |k|
          record << c[k.to_sym]
        end

        records << record.join(' ')
      end
    end
  end
end
