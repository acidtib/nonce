require "crest"
require "yaml"
require "json"

CONF = YAML.parse(File.read("/root/nonce.yml"))

module Nonce
  VERSION = "0.1.0"

  class BTC
    def self.getblockchaininfo
      data = `bitcoin-cli getblockchaininfo`
      Crest.post(
        "#{CONF["ping_host"]}/#{CONF["node_id"]}",
        headers: {"Content-Type" => "application/json"},
        form: data,
        logging: true
      )
    end
  end
end

puts Nonce::VERSION

Nonce::BTC.getblockchaininfo