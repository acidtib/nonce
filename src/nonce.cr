require "crest"

module Nonce
  VERSION = "0.1.0"

  class BTC
    def self.getblockchaininfo
      `bitcoin-cli getblockchaininfo`
    end
  end
end

puts Nonce::BTC.getblockchaininfo

puts "hello"
puts Nonce::VERSION