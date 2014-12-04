module Lita
  module Handlers
    class Dig < Handler
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
        case type
        when 'a', 'A'
          type = Net::DNS::A
        when 'ns', 'NS'
          type = Net::DNS::NS
        when 'md', 'MD'
          type = Net::DNS::MD
        when 'cname', 'CNAME'
          type = Net::DNS::CNAME
        when 'soa', 'SOA'
          type = Net::DNS::SOA
        when 'mb', 'MB'
          type = Net::DNS::MB
        when 'mg', 'MG'
          type = Net::DNS::MG
        when 'mr', 'MR'
          type = Net::DNS::MR
        when 'null', 'NULL'
          type = Net::DNS::NULL
        when 'wks', 'WKS'
          type = Net::DNS::WKS
        when 'ptr', 'PTR'
          type = Net::DNS::PTR
        when 'hinfo', 'HINFO'
          type = Net::DNS::HINFO
        when 'minfo', 'MINFO'
          type = Net::DNS::MINFO
        when 'mx', 'MX'
          type = Net::DNS::MX
        when 'txt', 'TXT'
          type = Net::DNS::TXT
        when 'rp', 'RP'
          type = Net::DNS::RP
        when 'afsdb', 'AFSDB'
          type = Net::DNS::AFSDB
        when 'x25', 'X25'
          type = Net::DNS::X25
        when 'isdn', 'ISDN'
          type = Net::DNS::ISDN
        when 'rt', 'RT'
          type = Net::DNS::RT
        when 'nsap', 'NSAP'
          type = Net::DNS::NSAP
        when 'nsapptr', 'NSAPPTR'
          type = Net::DNS::NSAPPTR
        when 'sig', 'SIG'
          type = Net::DNS::SIG
        when 'key', 'KEY'
          type = Net::DNS::KEY
        when 'px', 'PX'
          type = Net::DNS::PX
        when 'gpos', 'GPOS'
          type = Net::DNS::GPOS
        when 'aaaa', 'AAAA'
          type = Net::DNS::AAAA
        when 'loc', 'LOC'
          type = Net::DNS::LOC
        when 'nxt', 'NXT'
          type = Net::DNS::NXT
        when 'eid', 'EID'
          type = Net::DNS::EID
        when 'nimloc', 'NIMLOC'
          type = Net::DNS::NIMLOC
        when 'srv', 'SRV'
          type = Net::DNS::SRV
        when 'atma', 'ATMA'
          type = Net::DNS::ATMA
        when 'naptr', 'NAPTR'
          type = Net::DNS::NAPTR
        when 'kx', 'KX'
          type = Net::DNS::KX
        when 'cert', 'CERT'
          type = Net::DNS::CERT
        when 'dname', 'DNAME'
          type = Net::DNS::DNAME
        when 'opt', 'OPT'
          type = Net::DNS::OPT
        when 'ds', 'DS'
          type = Net::DNS::DS
        when 'sshfp', 'SSHFP'
          type = Net::DNS::SSHFP
        when 'rrsig', 'RRSIG'
          type = Net::DNS::RRSIG
        when 'nsec', 'NSEC'
          type = Net::DNS::NSEC
        when 'dnskey', 'DNSKEY'
          type = Net::DNS::DNSKEY
        when 'uinfo', 'UINFO'
          type = Net::DNS::UINFO
        when 'uid', 'UID'
          type = Net::DNS::UID
        when 'gid', 'GID'
          type = Net::DNS::GID
        when 'unspec', 'UNSPEC'
          type = Net::DNS::UNSPEC
        when 'tkey', 'TKEY'
          type = Net::DNS::TKEY
        when 'tsig', 'TSIG'
          type = Net::DNS::TSIG
        when 'ixfr', 'IXFR'
          type = Net::DNS::IXFR
        when 'axfr', 'AXFR'
          type = Net::DNS::AXFR
        when 'mailb', 'MAILB'
          type = Net::DNS::MAILB
        when 'maila', 'MAILA'
          type = Net::DNS::MAILA
        when 'any', 'ANY'
          type = Net::DNS::ANY
        else
          return t('error.unknown_type')
        end

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
