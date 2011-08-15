require 'spec_helper'

describe Arnold::YAMLizer do

  describe '.yamlize' do

    context 'when having an array of fixnums' do
      subject { Arnold::YAMLizer.yamlize([1,2,3]) }

      it { should include "[1, 2, 3]"}
    end

    context 'when having an array with a nested array' do
      subject { Arnold::YAMLizer.yamlize([1,2,[3]]) }

      it { should include "- 1\n- 2\n- [3]"}
    end

    context 'when having an array with a nested hash' do
      subject { Arnold::YAMLizer.yamlize([1,{2 => 3}]) }

      it { should include "- 1\n" }
      it { should include "2: 3" }
    end

  end

end
