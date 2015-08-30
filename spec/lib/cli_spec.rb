require 'spec_helper'

describe SugoiAliasesUpdator::Cli do
  describe '#direction_labels' do
    it 'return Array' do
      cli = SugoiAliasesUpdator::Cli.new([
        'filepath',
        'add',
        'hoge@foo.com',
        'TO=root,postfix'
      ])
      expect(
        cli.direction_labels
      ).to eq ['root', 'postfix']
    end
  end
end
