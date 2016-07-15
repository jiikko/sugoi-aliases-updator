require 'spec_helper'

describe SugoiAliasesUpdator::LineParser do
  let(:comment_line) { "# #{line}" }

  subject { SugoiAliasesUpdator::LineParser.new(line) }

  context 'when seplator is \t' do
    let(:line) { 'root:		 admin@exmaple.com, hoge@exmaple.com, postfix@exmaple.com' }
    it 'be valid margin' do
      expect(subject.margin).to eq '		 '
    end
    it 'be valid is_aliaes_line' do
      expect(subject.is_aliaes_line).to eq true
    end
    it 'be valid emails' do
      expect(
        subject.emails_line
      ).to eq 'admin@exmaple.com, hoge@exmaple.com, postfix@exmaple.com'
    end
    it 'be valid label' do
      expect(
        subject.label
      ).to eq 'root'
    end
  end

  context 'when seplator is \s' do
    it 'be valid margin' do
      expect(subject.margin).to eq '  '
    end
    let(:line) { 'root:  admin@exmaple.com, hoge@exmaple.com, postfix@exmaple.com, java-5@exmaple.com' }
    it 'be valid is_aliaes_line' do
      expect(subject.is_aliaes_line).to eq true
    end
    it 'be valid emails' do
      expect(
        subject.emails_line
      ).to eq 'admin@exmaple.com, hoge@exmaple.com, postfix@exmaple.com, java-5@exmaple.com'
    end
    it 'be valid label' do
      expect(
        subject.label
      ).to eq 'root'
    end
  end

  context 'when blank emails' do
    let(:line) { 'root: ' }
    it 'be valid is_aliaes_line' do
      expect(subject.is_aliaes_line).to eq true
    end
    it 'be valid emails' do
      expect(
        subject.emails_line
      ).to eq ''
    end
    it 'be valid label' do
      expect(
        subject.label
      ).to eq 'root'
    end
  end
end
