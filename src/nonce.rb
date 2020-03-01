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
          chain: data["chain"],
          blocks: data["blocks"],
          verificationprogress: data["verificationprogress"],
          initialblockdownload: data["initialblockdownload"],
          size_on_disk: data["size_on_disk"],
          pruned: data["pruned"]
        }
      else
        return {
          error: "issue getting blockchain info"
        }
      end   
    end
  end
end

getblockchaininfo = Nonce::BTC.getblockchaininfo

usage = `df -m #{CONF["path"]}`.split(/\b/)[26]
disk_usage = {disk_usage: usage}

Nonce::Helper.ping(getblockchaininfo.merge(disk_usage))