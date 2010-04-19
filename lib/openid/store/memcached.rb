require 'openid/util'
require 'openid/store/interface'
require 'openid/store/nonce'
require 'openid/store/memcache'
require 'time'
require 'memcached'

module OpenID
  module Store
    class Memcached < Memcache
      def get_association(server_url, handle=nil)
        begin
          serialized = cache_client.get(assoc_key(server_url, handle))
          return deserialize(serialized) if serialized
          return nil
        rescue ::Memcached::NotFound
          return nil
        end
      end

      def delete(key)
        begin
          cache_client.delete(key)
          return true
        rescue ::Memcached::NotFound
          return false
        end
      end
     
      def use_nonce(server_url, timestamp, salt)
        return false if (timestamp - Time.now.to_i).abs > Nonce.skew
        ts = timestamp.to_s # base 10 seconds since epoch
        nonce_key = key_prefix + 'N' + server_url + '|' + ts + '|' + salt               
        begin
          cache_client.add(nonce_key, '', expiry(Nonce.skew + 5))
          return true
        rescue ::Memcached::NotStored
          return false
        end
      end

    end
  end
end
