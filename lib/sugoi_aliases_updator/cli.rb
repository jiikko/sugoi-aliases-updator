module SugoiAliasesUpdator
  class Cli
    attr_reader :filepath, :target_email

    COMMANDS = %w(add rm del list show)

    def initialize(args)
      @filepath =         args[0] || ''
      @command =          args[1]
      @target_email =     args[2]
      @direction_labels = args[3]
    end

    def check_input
      display_version
      check_filepath
      check_command
      check_terget_email
      check_direction
    end

    def direction_labels
      raise("Oops '#{@direction_labels}'") unless /(TO|FROM)=(.*)$/ =~ @direction_labels
      $2.split(/,\s?/)
    end

    private

    def display_version
      return unless @filepath == '--version'
      require "sugoi_aliases_updator/version"
      puts SugoiAliasesUpdator::VERSION
      exit 0
    end

    def check_filepath
      return if File.exists?(@filepath)
      puts "file is not found "
      exit 1
    end

    def check_command
      return if COMMANDS.include?(@command)
      puts "input (#{COMMANDS.join("|")})"
      exit 1
    end


    def check_terget_email
      return if /\w*@.*/ =~ @target_email
      puts "input email"
      exit 1
    end

    def check_direction
      if %w(add rm).include?(@command) && @direction_labels.nil?
        need = { 'add' => 'TO', 'rm' => 'FROM' }
        puts "Usage: #{need[command]}=label1,label2"
        exit 1
      end
    end
  end
end
