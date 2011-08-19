shared_examples_for 'Arnold' do

  let :arnold do
    { :id => 1, :name => 'Arnold', :job => 'Boss', :rank => 1 }
  end

  let :bob do
    { :id => 9, :name => 'Bob', :job => 'Worker', :rank => 5 }
  end

  before do
    arnold.each_pair{ |k, v| subject.send(:write_attribute, k, v) }
  end

  it 'should have Arnold included automatically' do
    subject.class.ancestors.should include Arnold
  end

  describe '#edit' do

    it "should update the object's fields" do
      subject.stubs(:change).returns(Arnold::YAMLizer.yamlize(bob))
      subject.edit

      bob.each_pair{ |k, v| subject.read_attribute(k).should == v }
      subject.id.should_not be_nil
    end

    it "should update just the given object's fields" do
      to_change = bob.reject{ |k, v| k == :name }
      subject.stubs(:change).returns(Arnold::YAMLizer.yamlize(to_change))

      subject.edit(:job, "rank")
      to_change.each_pair{ |k, v| subject.read_attribute(k).should == v }
      subject.read_attribute(:name).should == arnold[:name]
      subject.id.should_not be_nil
    end
  end

  describe '#edit!' do

    it "should update and save the object" do
      subject.stubs(:change).returns(Arnold::YAMLizer.yamlize(bob))
      subject.expects(:edit)
      subject.expects(:save!)
      subject.edit!
    end

  end

  describe '#tempfile' do

    it 'should store the yaml-ized object into a tempfile' do
      attributes = YAML.load_file(subject.send(:tempfile))
      attributes['name'].should == arnold[:name]
    end

    it 'should store the yaml-ized object into a tempfile just with the selected attributes' do
      attributes = YAML.load_file(subject.send(:tempfile, :job, "rank"))
      attributes['job'].should == arnold[:job]
      attributes['rank'].should == arnold[:rank]
      attributes['name'].should be_nil
    end
  end

  describe '#editor' do

    it "should return notepad by default on windows" do
      Arnold::Utils.stubs(:windows?).returns true
      ENV.stubs(:[]).with('EDITOR').returns nil
      subject.send(:editor).should == 'notepad'
    end

    it "should return vi by default" do
      Arnold::Utils.stubs(:windows?).returns false
      ENV.stubs(:[]).with('EDITOR').returns nil
      subject.send(:editor).should == 'vi'
    end

    it "should return vi by default" do
      ENV.stubs(:[]).with('EDITOR').returns 'vi'
      subject.send(:editor).should == 'vi'
    end

    it "should switch to the blocking version of the editor" do
      ENV.stubs(:[]).with('EDITOR').returns 'mate'
      subject.send(:editor).should == 'mate -w'
    end

  end

  describe "#editable_attributes" do

    let(:keys){ subject.send(:editable_attributes).keys }

    it "should not contain an id" do
      keys.should_not include('id')
      keys.should_not include('_id')
    end

  end

  describe 'the tempfile' do
    let(:keys){ YAML.load_file(subject.send(:tempfile)).keys }

    it 'should not store an id' do
      keys.should_not include('id')
      keys.should_not include('_id')
    end

  end
end
