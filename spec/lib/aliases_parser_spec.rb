require 'spec_helper'
require 'tempfile'

describe SugoiAliasesUpdator::AliasesParser do
  let(:source_aliases_flle) {
    tempfile = Tempfile.new('aliases')
    File.write(tempfile.path, source_aliases)
    tempfile
  }
  let(:source_aliases) { <<-ALIASES
MAILER-DAEMON:	postmaster
postmaster:	root

# General redirections for pseudo accounts
bin:		root
daemon:		root
named:		root, n905i.1214@gmail.com
nobody:		root, n905i.1214@gmail.com
uucp:		root
www:		root, n905i.1214@gmail.com, java@java.com
                         ALIASES
  }

  describe '#add' do
    let(:expected) { <<-ALIASES
MAILER-DAEMON:	postmaster
postmaster:	root

# General redirections for pseudo accounts
bin:		root, admin@github.com
daemon:		root
named:		root, n905i.1214@gmail.com
nobody:		root, n905i.1214@gmail.com
uucp:		root
www:		root, n905i.1214@gmail.com, java@java.com, admin@github.com
                     ALIASES
    }
    it 'add target' do
      aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
        source_aliases_flle.path
      )
      actual = aliases_parser.add('admin@github.com', to: %w(bin www))
      expect(actual).to eq expected
      source_aliases_flle.unlink
    end

    context 'when exist email' do
      let(:expected) { <<-ALIASES
MAILER-DAEMON:	postmaster
postmaster:	root

# General redirections for pseudo accounts
bin:		root
daemon:		root
named:		root, n905i.1214@gmail.com
nobody:		root, n905i.1214@gmail.com
uucp:		root
www:		root, n905i.1214@gmail.com, java@java.com
                       ALIASES
      }
      it "don't duplicate" do
        aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
          source_aliases_flle.path
        )
        actual = aliases_parser.add('n905i.1214@gmail.com', to: %w(named www))
        expect(actual).to eq expected
        source_aliases_flle.unlink
      end
    end
  end

  describe '#rm' do
    let(:expected) { <<-ALIASES
MAILER-DAEMON:	postmaster
postmaster:	root

# General redirections for pseudo accounts
bin:		root
daemon:		root
named:		root
nobody:		root, n905i.1214@gmail.com
uucp:		root
www:		root, java@java.com
                     ALIASES
    }
    it 'remove target' do
      aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
        source_aliases_flle.path
      )
      actual = aliases_parser.rm('n905i.1214@gmail.com', from: %w(www named))
      expect(actual).to eq expected
      source_aliases_flle.unlink
    end

    context 'when FROM=ALL' do
      let(:expected) { <<-ALIASES
MAILER-DAEMON:	postmaster
postmaster:	root

# General redirections for pseudo accounts
bin:		root
daemon:		root
named:		root
nobody:		root
uucp:		root
www:		root, java@java.com
                       ALIASES
      }

      it 'remove all target' do
        aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
          source_aliases_flle.path
        )
        actual = aliases_parser.rm('n905i.1214@gmail.com', from: %w(ALL))
        expect(actual).to eq expected
        source_aliases_flle.unlink
      end
    end

    context 'when inputed unknown label' do
      it 'show message' do
        aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
          source_aliases_flle.path
        )
        expect {
          aliases_parser.rm('n905i.1214@gmail.com', from: %w(hoge))
        }.to raise_error(RuntimeError)
        source_aliases_flle.unlink
      end
    end
  end

  describe '#list' do
    let(:expected) { 'named,nobody,www' }
    it 'return labels' do
      aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
        source_aliases_flle.path
      )
      actual = aliases_parser.list('n905i.1214@gmail.com')
      expect(actual).to eq expected
      source_aliases_flle.unlink
    end
  end
end
