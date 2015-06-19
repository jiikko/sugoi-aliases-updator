module SugoiAliasesUpdator
  class LineParser
    attr_accessor :emails_line, :label

    def initialize(line)
      @line = line
    end

    def aliaes_line?
      if /^(.*):\s*(.*)$/ =~ @line
        @emails_line = $2
        @label = $1
      end
    end
  end
end
