require 'mongoid'
require 'mocha'
require 'arnold'

shared_examples_for 'Arnold' do

  before do
    subject.write_attribute(:name, 'Arnold')
  end

  it 'should have Arnold included automatically' do
    subject.class.ancestors.should include Arnold
  end

  describe '#update' do

    it "should update the object's fields" do
      subject.stubs(:change).returns({:name => 'Bob'}.to_yaml)
      subject.update
      subject.read_attribute(:name).should == 'Bob'
    end

  end

  describe '#tempfile' do

    it 'should store the yaml-ized object into a tempfile' do
      attributes = YAML.load_file(subject.send(:tempfile))
      attributes['name'].should == 'Arnold'
    end

  end

end

class MongoidDocument
  include Mongoid::Document
end

describe MongoidDocument do
  it_should_behave_like 'Arnold'
end
