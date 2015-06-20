require 'spec_helper'

require 'tempfile'

describe SugoiAliasesUpdator::AliasesParser do

  let(:source_aliases) { <<-ALIASES
MAILER-DAEMON:	postmaster
postmaster:	root

# General redirections for pseudo accounts
bin:		root
daemon:		root
named:		root
nobody:		root
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
named:		root
nobody:		root
uucp:		root
www:		root, n905i.1214@gmail.com, admin@github.com
  ALIASES
  }

   it 'add target' do
     tempfile = Tempfile.new('aliases')
     File.write(tempfile.path, source_aliases)
     aliases_parser = SugoiAliasesUpdator::AliasesParser.new(tempfile.path)
     actuial  = aliases_parser.add('admin@github.com', to: %w(bin www))
     expect(actuial).to eq expected
     tempfile.unlink
   end
 end
end
