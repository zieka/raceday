class Racer
  include Mongoid::Document

  def self.mongo_client
    db = Mongoid::Clients.default
  end

  def self.collection
    result = self.mongo_client['racers']
  end
end
