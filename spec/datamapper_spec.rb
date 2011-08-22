require 'spec_helper'

DataMapper.setup(:default, "abstract::")

class DataMapperResource
  include DataMapper::Resource

  property :id,   Serial
  property :name, String
  property :job,  String
  property :rank, Integer

  def write_attribute(name, value)
    attribute_set(name, value)
  end

  def read_attribute(name)
    attribute_get(name)
  end

  def attributes
    DataMapper::Mash.new(super)
  end
end

describe DataMapperResource do
  it_should_behave_like 'Arnold'
end
