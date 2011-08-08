require 'spec_helper'

ActiveRecord::Base.class_eval do
  alias_method :save, :valid?
  
  def self.columns; @columns ||= []; end
  
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
  end
end

class ActiveRecordRow < ActiveRecord::Base
  column :name
end

describe ActiveRecordRow do
  it_should_behave_like 'Arnold'
end
