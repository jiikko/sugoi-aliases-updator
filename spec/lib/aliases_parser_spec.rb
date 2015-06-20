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
www:		root, n905i.1214@gmail.com
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
www:		root, n905i.1214@gmail.com, admin@github.com
                     ALIASES
    }

    it 'add target' do
      aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
        source_aliases_flle.path
      )
      actuial  = aliases_parser.add('admin@github.com', to: %w(bin www))
      expect(actuial).to eq expected
      source_aliases_flle.unlink
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
www:		root
                     ALIASES
    }

    it 'remove target' do
      aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
        source_aliases_flle.path
      )
      actuial = aliases_parser.rm('n905i.1214@gmail.com', from: %w(www named))
      expect(actuial).to eq expected
      source_aliases_flle.unlink
    end
  end

  describe '#list' do
    let(:expected) { 'named nobody www' }
    it 'return labels' do
      aliases_parser = SugoiAliasesUpdator::AliasesParser.new(
        source_aliases_flle.path
      )
      actuial = aliases_parser.list('n905i.1214@gmail.com')
      expect(actuial).to eq expected
      source_aliases_flle.unlink
    end
  end
end
