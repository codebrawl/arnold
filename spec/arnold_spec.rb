describe 'Array' do

  describe '#to_yaml' do

    context 'when having an array of fixnums' do
      subject { [1,2,3].to_yaml }

      it { should == "--- [1, 2, 3]\n"}
    end

    context 'when having an array with a nested array' do
      subject { [1,2,[3]].to_yaml }

      it { should == "--- \n- 1\n- 2\n- [3]\n"}
    end

    context 'when having an array with a nested hash' do
      subject { [1,{2 => 3}].to_yaml }

      it { should == "--- \n- 1\n- 2: 3\n"}
    end

  end

end
