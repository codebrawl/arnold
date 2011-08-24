require 'spec_helper'

DataMapper.setup(:default, "abstract::")

class DataMapperResource
  include DataMapper::Resource

  property :id,   Serial
  property :name, String
  property :job,  String
  property :rank, Integer
end

describe DataMapperResource do
  it_should_behave_like 'Arnold'
end
