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
  end

  class BTC
    def self.getblockchaininfo
      data = `bitcoin-cli getblockchaininfo`

      if Helper.valid_json?(data)
        HTTParty.post("#{CONF["ping_host"]}/#{CONF["node_id"]}",
          :body => data,
          :headers => { 'Content-Type' => 'application/json' } 
        )
      end   
    end
  end
end

Nonce::BTC.getblockchaininfo