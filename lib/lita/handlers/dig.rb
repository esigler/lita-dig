module Lita
  module Handlers
    class Dig < Handler
      route(
        /^dig\s(\S+)$/,
        :resolve,
        command: true,
        help: {
          t('help.resolve.syntax') => t('help.resolve.desc')
        }
      )

      route(
        /^dig\s(\S+)\s(\S+)$/,
        :resolve_type,
        command: true,
        help: {
          t('help.resolve_type.syntax') => t('help.resolve_type.desc')
        }
      )

      def resolve(response)
        response.reply(format_lookup(lookup(response.matches[0][0])))
      end

      def resolve_type(response)
        case response.matches[0][1]
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
          return response.reply(t('error.unknown_type'))
        end
        response.reply(format_lookup(lookup(response.matches[0][0], type)))
      end

      private

      def lookup(argument, type = Net::DNS::A, cls = Net::DNS::IN)
        resolver = Net::DNS::Resolver.new
        begin
          resolver.query(argument, type, cls)
        rescue
          "Unable to resolve #{argument}"
        end
      end

      def format_lookup(lookup)
        lookup.to_s
      end
    end

    Lita.register_handler(Dig)
  end
end
