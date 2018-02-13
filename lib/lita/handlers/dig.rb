# frozen_string_literal: true

module Lita
  module Handlers
    class Dig < Handler
      config :default_resolver, default: '8.8.8.8'

      DNS_TYPES = %w[a aaaa afsdb any atma axfr cert cname dname dnskey
                     ds eid gid gpos hinfo isdn ixfr key kx loc maila
                     mailb mb md mg minfo mr mx naptr nimloc ns nsap
                     nsapptr nsec null nxt opt ptr px rp rrsig rt sig
                     soa srv sshfp tkey tsig txt uid uinfo unspec wks
                     x25].freeze

      route(
        /^dig
          (?:\s\@)?(?<resolver>\S+)?
          (\s+(?<record>\S+))
          (\s+)?
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
        resolver = response.match_data['resolver'] || config.default_resolver
        record   = response.match_data['record']
        type     = (response.match_data['type'] || 'a').strip
        short    = response.match_data['short']
        result   = lookup(record, type, resolver)

        response.reply(format_lookup(result, short))
      end

      private

      def lookup(argument, type, server)
        return t('error.unknown_type') unless DNS_TYPES.include?(type.downcase)

        type = Object.const_get('Net::DNS::' + type.upcase)
        resolver = Net::DNS::Resolver.new
        resolver.nameservers = server

        resolver.query(argument, type)
      rescue StandardError
        t('error.unable_to_resolve', argument: argument)
      end

      def format_lookup(lookup, compact = false)
        template = compact ? 'compact' : 'full'
        render_template(template, lookup: lookup)
      end
    end

    Lita.register_handler(Dig)
  end
end
