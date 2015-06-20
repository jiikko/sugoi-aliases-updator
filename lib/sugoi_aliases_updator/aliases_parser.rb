module SugoiAliasesUpdator
  class AliasesParser

    attr_accessor :changed_labels

    def self.parse_direction_labels(string)
      if /(TO|FROM)=(.*)$/ =~ string
        labels = $2.split(/,\s?/)
      else
        puts "Usage: TO|FROM=values"
      end
    end

    def initialize(filepath)
      @native_lines = File.readlines(filepath)
      @changed_labels = []
    end

    def add(target_email, to: )
      to.each do |x|
        unless label_mails_hash[x].include?(target_email)
          label_mails_hash[x].push(target_email)
          @changed_labels << x
        end
      end
      render!
    end

    def rm(target_email, from: )
      from.each do |x|
        if label_mails_hash[x].include?(target_email)
          puts label_mails_hash[x]
          label_mails_hash[x].delete(target_email)
          @changed_labels << x
        end
      end
      render!
    end

    def list(target_email)
      finded = []
      label_mails_hash.each do |key, value|
        finded.push(key) if value.include?(target_email)
      end
      finded.join
    end

    def render!
      new_lines = []
      @native_lines.each do |line|
        line_paser = LineParser.new(line)
        if line_paser.is_aliaes_line && @changed_labels.include?(line_paser.label)
          line = "#{line_paser.label}:#{line_paser.margin}#{label_mails_hash[line_paser.label].join(", ")}\n"
        end
        new_lines << line
      end
      new_lines.join
    end

    private

    def label_mails_hash
      @label_mails_hash ||= {}.tap do |h|
        @native_lines.each do |line|
          line_paser = LineParser.new(line)
          if line_paser.is_aliaes_line
            emails_line = line_paser.emails_line
            h[line_paser.label] = line_paser.emails_line.split(/\,\s?/)
          end
        end
      end
    end
  end
end
