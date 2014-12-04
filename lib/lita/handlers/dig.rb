module Lita
  module Handlers
    class Dig < Handler
      DNS_TYPES = %w(a ns md cname soa mb mg mr null wks ptr hinfo minfo
                     mx txt rp afsdb x25 isdn rt nsap nsapptr sig key px
                     gpos aaaa loc nxt eid nimloc srv atma naptr kx cert
                     dname opt ds sshfp rrsig nsec dnskey uinfo uid gid
                     unspec tkey tsig ixfr axfr mailb maila any)

      route(
        /^dig\s(\S+)(\s\+short)?$/,
        :resolve,
        command: true,
        help: {
          t('help.resolve.syntax') => t('help.resolve.desc')
        }
      )

      route(
        /^dig\s(?!\@)(\S+)\s(\S+)$/,
        :resolve_type,
        command: true,
        help: {
          t('help.resolve_type.syntax') => t('help.resolve_type.desc')
        }
      )

      route(
        /^dig\s\@(\S+)\s(\S+)(\s\+short)?$/,
        :resolve_svr,
        command: true,
        help: {
          t('help.resolve_svr.syntax') => t('help.resolve_svr.desc')
        }
      )

      route(
        /^dig\s\@(\S+)\s(\S+)\s(\S+)$/,
        :resolve_svr_type,
        command: true,
        help: {
          t('help.resolve_svr_type.syntax') => t('help.resolve_svr_type.desc')
        }
      )

      def resolve(response)
        name    = response.matches[0][0]
        compact = response.matches[0][1] == ' +short'
        result  = lookup(name, 'a')
        response.reply(format_lookup(result, compact))
      end

      def resolve_type(response)
        name = response.matches[0][0]
        type = response.matches[0][1]
        response.reply(format_lookup(lookup(name, type))) \
          unless type == '+short'
      end

      def resolve_svr(response)
        resolver = response.matches[0][0]
        name     = response.matches[0][1]
        compact  = response.matches[0][2] == ' +short'
        result   = lookup(name, 'a', resolver)
        response.reply(format_lookup(result, compact))
      end

      def resolve_svr_type(response)
        resolver = response.matches[0][0]
        name     = response.matches[0][1]
        type     = response.matches[0][2]
        response.reply(format_lookup(lookup(name, type, resolver))) \
          unless type == '+short'
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
