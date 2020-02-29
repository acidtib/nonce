require 'net/http'
require 'uri'
require 'json'

class BitcoinRPC
  def initialize(service_url)
    @uri = URI.parse(service_url)
  end

  def method_missing(name, *args)
    post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
    resp = JSON.parse( http_post_request(post_body) )
    raise JSONRPCError, resp['error'] if resp['error']
    resp['result']
  end

  def http_post_request(post_body)
    http    = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Post.new(@uri.request_uri)
    request.basic_auth @uri.user, @uri.password
    request.content_type = 'application/json'
    request.body = post_body
    http.request(request).body
  end

  class JSONRPCError < RuntimeError; end
end

if $0 == __FILE__
  h = BitcoinRPC.new('http://durathanane30146e:63df1a44666656d93209658ef6cc9fb6dc99a77a4b44f9f990e7f68fb514b50b@64.225.6.133:18332')
  # p h.getbalance
  p h.getblockchaininfo
  # p h.getnewaddress
  # p h.dumpprivkey( h.getnewaddress )
  # also see: https://en.bitcoin.it/wiki/Original_Bitcoin_client/API_Calls_list
end

# curl --user durathanane30146e --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://64.225.6.133:18332/