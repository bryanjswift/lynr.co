require './lib/lynr/persist/mongo_dao'
require './lib/lynr/model/dealership'

module Lynr; module Persist;

  class DealershipDao

    def initialize
      @dao = MongoDao.new('dealers')
    end

    def get(id)
      record = @dao.get(id)
      # Mongo is going to give me a record with the _id property set, not id
      record[:id] = record.delete(:_id)
      Lynr::Model::Dealership.inflate(record)
    end

    def save(dealer)
      record = @dao.save(dealer.view, dealer.id)
      Lynr::Model::Dealership.inflate(record)
    end

  end

end; end;