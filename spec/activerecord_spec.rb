require 'spec_helper'

ActiveRecord::Base.establish_connection({  
  :adapter => 'sqlite3',
  :database => ':memory:'
})

ActiveRecord::Schema.define do
 suppress_messages { create_table "bosses", :force => true }
end

class Boss < ActiveRecord::Base
end

describe Boss do
  it_should_behave_like 'Arnold'
end
