require 'spec_helper'

describe Arnold::YAMLizer do

  describe '.yamlize' do
    
    context 'when having an hash with no arrays' do
      subject { Arnold::YAMLizer.yamlize("a" => 1, "b" => 2) }
      
      it { should_not include "{" }
    end

    context 'when having an array of fixnums' do
     subject { Arnold::YAMLizer.yamlize([1, 2, 3]) }

     it { should include "[1, 2, 3]"}
    end

    context 'when having an array with a nested array' do
      subject { Arnold::YAMLizer.yamlize([1, [2, 3]]) }

      it { should include "- 1\n- [2, 3]"}
    end
    
    context 'when having an array with a nested hash' do
      subject { Arnold::YAMLizer.yamlize([1, {2 => 3}]) }
    
      it { should include "- 1\n" }
      it { should include "2: 3" }
    end
    
    context 'when having an hash with an array among values' do
      subject { Arnold::YAMLizer.yamlize("a" => 1, "b" => 2, "c" => [1, 2]) }
      
      it { should_not include "{" }
      it { should include "[1, 2]"}
    end

  end

end
