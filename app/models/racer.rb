class Racer
  include Mongoid::Document
  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs


  #database client
  def self.mongo_client
    db = Mongoid::Clients.default
  end

  #finds collection of racers
  def self.collection
    result = self.mongo_client['racers']
  end

  #finds all records in document
  def self.all(prototype={}, sort={:number => 1}, skip=0, limit=nil)
    #find all racers that match the given prototype
    #sort them by the given hash criteria
    #skip the specified number of documents
    result = collection.find(prototype).sort(sort).skip(skip)

    #limit the number of documents returned if limit is specified
    #return the result
    unless limit.nil?
      result = result.limit(limit)
    end
    result
  end

  #accept parameters to set id, number, first_name, last_name, gender, group, secs
  def initialize(params={})
    @id=params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number=params[:number].to_i
    @first_name=params[:first_name]
    @last_name=params[:last_name]
    @gender=params[:gender]
    @group=params[:group]
    @secs=params[:secs].to_i
  end

  #accept a single id parameter that is either a string or BSON::ObjectId
  #  Note: it must be able to handle either format.
  #find the specific document with that _id
  #return the racer document represented by that id
  def self.find id
    result=collection.find(:_id => BSON::ObjectId.from_string(id))
  				  .projection({
              _id:true,
              number:true,
              first_name:true,
              last_name:true,
              gender:true,
              group:true,
              secs:true
            })
  					.first
    return result.nil? ? nil : Racer.new(result)
  end
end
