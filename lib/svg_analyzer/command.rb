module SvgAnalyzer
  CommandConfiguration = Struct.new(:char, :arg_count, :x_index, :y_index, :x_args, :y_args)

  class Command
    delegate :absolute?, :superclass, *CommandConfiguration.members, to: :class
    attr_reader :arguments, :previous

    def initialize(*args, previous: Start.instance)
      @arguments = args.map { |n| n.to_s.include?('.') ? n.to_f.round(9) : n.to_i }
      @previous = previous
    end

    def to_s
      skip_char = previous.class == self.class && self.class.repeats_become == self.class
      [skip_char ? ' ' : char, *arguments].join(' ')
    end

    def starting_x
      previous.final_x
    end

    def starting_y
      previous.final_y
    end

    def final_x
      return starting_x if x_index.nil?

      x_value = arguments[x_index]
      absolute? ? x_value : starting_x + x_value
    end

    def final_y
      return starting_y if y_index.nil?

      y_value = arguments[y_index]
      absolute? ? y_value : starting_y + y_value
    end

    def absolute
      return self if absolute?

      @absolute ||= begin
        new_args = arguments.zip(argument_offsets).map(&:sum)
        superclass::Absolute.new(*new_args, previous: previous)
      end
    end

    def relative
      return self unless absolute?

      @relative ||= begin
        new_args = arguments.zip(argument_offsets.map(&:-@)).map(&:sum)
        superclass::Relative.new(*new_args, previous: previous)
      end
    end

    def argument_offsets
      arg_count.times.map do |i|
        case i
        when x_args.to_set then starting_x
        when y_args.to_set then starting_y
        else 0
        end
      end
    end

    class << self
      attr_reader :configuration
      delegate *CommandConfiguration.members, to: :configuration, allow_nil: true

      def new(char, *args)
        self == Command ? find(char).new(*args) : super
      end

      def registry
        @registry ||= {}.with_indifferent_access
      end

      def repeats_become
        self
      end

      def config(char = nil, arg_count = nil, x: nil, y: nil, x_args: Array(x), y_args: Array(y))
        @configuration = CommandConfiguration.new(char, arg_count, x, y, x_args, y_args)
        yield(@configuration) if block_given?
        # Order matters because the Absolute overrides the Relative for the Start subclass
        Command.registry[self::Relative.char] = self::Relative
        Command.registry[self::Absolute.char] = self::Absolute
      end

      def find(char)
        Command.registry[char]
      end

      def inherited(subclass)
        super
        return unless self == Command

        SvgAnalyzer::Absolute.build(subclass)
        SvgAnalyzer::Relative.build(subclass)
      end
    end
  end
end
