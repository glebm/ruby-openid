require 'openid/util'
require 'openid/store/interface'
require 'openid/store/nonce'
require 'openid/store/memcache'
require 'time'

module OpenID
  module Store
    class Memcached < Memcache
      def get_association(server_url, handle=nil)
        begin
          serialized = cache_client.get(assoc_key(server_url, handle)
          return deserialize(serialized) if serialized
          return nil
        rescue 
          return nil
        end
      end
    end
  end
end
