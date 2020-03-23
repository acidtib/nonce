require 'yaml'
require 'json'
require 'httparty'

CONF = YAML.load_file("/root/nonce.yml")

module Nonce
  class Helper
    def self.valid_json?(json)
      begin
        JSON.parse(json)
        return true
      rescue JSON::ParserError => e
        return false
      end
    end

    def self.ping(data)
      HTTParty.post("#{CONF["ping_host"]}/#{CONF["node_id"]}",
        :body => data.to_json,
        :headers => { 'Content-Type' => 'application/json' } 
      )
    end
  end

  class BTC
    def self.getblockchaininfo
      data = `/usr/local/bin/bitcoin-cli getblockchaininfo`

      if Helper.valid_json?(data)
        j = JSON.parse(data)
        return {
          chain: j["chain"],
          blocks: j["blocks"],
          verificationprogress: j["verificationprogress"],
          initialblockdownload: j["initialblockdownload"],
          size_on_disk: j["size_on_disk"],
          pruned: j["pruned"]
        }
      else
        return {
          error: "issue getting blockchain info"
        }
      end   
    end
  end

  class BSV
    def self.getblockchaininfo
      data = `/usr/local/bin/bitcoin-cli getblockchaininfo`

      if Helper.valid_json?(data)
        j = JSON.parse(data)
        return {
          chain: j["chain"],
          blocks: j["blocks"],
          verificationprogress: j["verificationprogress"],
          pruned: j["pruned"]
        }
      else
        return {
          error: "issue getting blockchain info"
        }
      end   
    end
  end

  class LTC
    def self.getblockchaininfo
      data = `/usr/local/bin/litecoin-cli getblockchaininfo`

      if Helper.valid_json?(data)
        j = JSON.parse(data)
        return {
          chain: j["chain"],
          blocks: j["blocks"],
          verificationprogress: j["verificationprogress"],
          initialblockdownload: j["initialblockdownload"],
          size_on_disk: j["size_on_disk"],
          pruned: j["pruned"]
        }
      else
        return {
          error: "issue getting blockchain info"
        }
      end   
    end
  end
end

case CONF["blockchain"]
when "bitcoin-core"
  getblockchaininfo = Nonce::BTC.getblockchaininfo
when "bitcoin-sv"
  getblockchaininfo = Nonce::BSV.getblockchaininfo
when "litecoin"
  getblockchaininfo = Nonce::LTC.getblockchaininfo
end

usage = `df -m #{CONF["path"]}`.split(/\b/)[26]
disk_usage = {disk_usage: usage}

Nonce::Helper.ping(getblockchaininfo.merge(disk_usage))