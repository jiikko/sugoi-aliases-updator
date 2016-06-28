module SugoiAliasesUpdator
  class LineParser
    attr_accessor :emails_line, :label, :is_aliaes_line, :margin

    def initialize(line)
      @is_aliaes_line = /^(.*):(\s*)([\w@\., -]*)/ === line
      @label = $1
      @margin = $2 && $2.delete(?\n)
      @emails_line = $3
    end
  end
end
