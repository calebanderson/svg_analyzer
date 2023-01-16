require "svg_analyzer/version"
require 'svg_analyzer/command'
require 'svg_analyzer/command_subclass'
require 'svg_analyzer/image'
require "svg_analyzer/railtie"

module SvgAnalyzer
  class Start < Command
    config('!', 2, x: 0, y: 1)

    def self.instance
      Command.new('!', 0, 0, previous: nil)
    end
  end

  class Line < Command
    config(:l, 2, x: 0, y: 1)
  end

  class Move < Command
    config(:m, 2, x: 0, y: 1)

    def self.repeats_become
      absolute? ? Line::Absolute : Line::Relative
    end
  end

  class Bezier < Command
    config(:c, 6, x: 4, y: 5, x_args: [0, 2, 4], y_args: [1, 3, 5])
  end

  class Arc < Command
    config(:a, 7, x: 5, y: 6)
  end

  class Horizontal < Command
    config(:h, 1, x: 0)
  end

  class Vertical < Command
    config(:v, 1, y: 0)
  end

  class Return < Command
    config(:z, 0)

    def starting_x
      prev = previous
      prev = prev.previous until prev.is_a?(Move) || prev.is_a?(Start)
      prev.final_x
    end

    def starting_y
      prev = previous
      prev = prev.previous until prev.is_a?(Move) || prev.is_a?(Start)
      prev.final_y
    end
  end
end
