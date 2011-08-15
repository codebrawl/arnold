shared_examples_for 'Arnold' do

  before do
    subject.send(:write_attribute, :name, 'Arnold')
  end

  it 'should have Arnold included automatically' do
    subject.class.ancestors.should include Arnold
  end

  describe '#edit' do

    it "should update the object's fields" do
      subject.stubs(:change).returns(Arnold::YAMLizer.yamlize({:name => 'Bob'}))
      subject.edit
      subject.read_attribute(:name).should == 'Bob'
    end

  end

  describe '#edit!' do

    it "should update and save the object" do
      subject.stubs(:change).returns(Arnold::YAMLizer.yamlize({:name => 'Bob'}))
      subject.expects(:edit)
      subject.expects(:save!)
      subject.edit!
    end

  end

  describe '#tempfile' do

    it 'should store the yaml-ized object into a tempfile' do
      attributes = YAML.load_file(subject.send(:tempfile))
      attributes['name'].should == 'Arnold'
    end

  end

  describe '#editor' do

    it "should return notepad by default on windows" do
      Arnold::Utils.stubs(:windows?).returns true
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
