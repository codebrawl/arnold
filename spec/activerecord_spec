require 'spec_helper'

ActiveRecord::Base.class_eval do
  def self.columns
    @columns ||= []
  end

  def self.column(name, default = nil)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, nil)
  end
end

class ActiveRecordRow < ActiveRecord::Base
  column :id
  column :name
end

describe ActiveRecordRow do
  it_should_behave_like 'Arnold'
end
