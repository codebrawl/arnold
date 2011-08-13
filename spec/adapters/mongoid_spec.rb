require 'spec_helper'

class MongoidDocument
  include Mongoid::Document
end

describe MongoidDocument do
  it_should_behave_like 'Arnold'
  it_should_behave_like 'Arnold used with Mongoid'
end
