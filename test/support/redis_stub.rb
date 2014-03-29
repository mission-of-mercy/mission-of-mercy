# From the blog of Francis Hwang
# http://fhwang.net/2010/09/23/Testing-Rails-against-a-running-Redis-instance-and-doing-it-with-Hydra-to-boot
#
class RedisStub
  def initialize
    @atoms = {}
  end

  def get(key)
    @atoms[key]
  end

  def set(key, value)
    @atoms[key.to_s] = value.to_s
    'OK'
  end
end
