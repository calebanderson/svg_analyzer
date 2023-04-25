module SvgAnalyzer
  class Image
    attr_reader :text
    delegate :command_regex, :text_separator, to: :class

    def self.command_regex
      /[#{Command.registry.keys.join}]/i
    end

    def self.text_separator
      /[,\s]+|(?=-)|(?<=#{command_regex})|(?=#{command_regex})/
    end

    def initialize(text)
      @text = text.to_s.squish
    end

    def to_s(form = nil)
      commands(*form).join("\n")
    end

    def css_path(form = nil)
      "path(\"#{squished(*form)}\");"
    end

    def squished(form = nil)
      to_s(*form).squish.remove(/(?<!\d) | (?!\d)/)
    end

    def elements
      @elements ||= begin
        text.split(text_separator).slice_before(command_regex).flat_map do |(type, *args)|
          # Blocks weren't always evaluated in a way that allows rescue without begin
          begin
            command = Command.find(type)
            args.each_slice(command.arg_count).with_object([]) do |arg_set, result|
              result << [command.char, *arg_set]
              command = command.repeats_become
            end
          rescue ArgumentError # 0 arg_count passed to #each_slice
            [[type]]
          end
        end
      end
    end

    def commands(form = :itself)
      commands = [Start.instance]
      elements.flat_map do |args|
        commands << Command.new(*args, previous: commands.last).send(form)
      end
      commands[1..-1]
    end
  end
end
