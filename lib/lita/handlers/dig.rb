module Lita
  module Handlers
    class Dig < Handler
      DNS_TYPES = %w(a ns md cname soa mb mg mr null wks ptr hinfo minfo
                     mx txt rp afsdb x25 isdn rt nsap nsapptr sig key px
                     gpos aaaa loc nxt eid nimloc srv atma naptr kx cert
                     dname opt ds sshfp rrsig nsec dnskey uinfo uid gid
                     unspec tkey tsig ixfr axfr mailb maila any)

      route(
        /^dig
          (?:\s\@)?(?<resolver>\S+)?
          (\s+(?<record>\S+))
          (?<type>\s\w+)?
          (?<short>\s\+short)?$
        /x,
        :resolve,
        command: true,
        help: {
          t('help.resolve.syntax') => t('help.resolve.desc')
        }
      )

      def resolve(response)
        resolver = response.match_data['resolver'] || '8.8.8.8'
        record   = response.match_data['record']
        type     = (response.match_data['type'] || 'a').strip
        short    = response.match_data['short']
        result   = lookup(record, type, resolver)
        response.reply(format_lookup(result, short))
      end

      private

      def lookup(argument, type, server = nil)
        return t('error.unknown_type') unless DNS_TYPES.include?(type.downcase)
        type = Object.const_get('Net::DNS::' + type.upcase)

        resolver = Net::DNS::Resolver.new
        resolver.nameservers = server unless server.nil?

        begin
          resolver.query(argument, type)
        rescue
          t('error.unable_to_resolve', argument: argument)
        end
      end

      def format_lookup(lookup, compact = false)
        result = ''
        if compact
          lookup.each_address do |ip|
            result += "#{ip}\n"
          end
        else
          result = lookup.to_s
        end
        result
      end
    end

    Lita.register_handler(Dig)
  end
end
