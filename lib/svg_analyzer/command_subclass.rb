module SvgAnalyzer
  module CommandSubclass
    def extended(base)
      super
      base.singleton_class.delegate(:configuration, to: :superclass)
    end

    def build(parent_class)
      parent_class.const_set(name.demodulize, Class.new(parent_class).extend(self))
    end
  end

  module Absolute
    extend CommandSubclass

    def char
      super.to_s.upcase
    end

    def absolute?
      true
    end
  end

  module Relative
    extend CommandSubclass

    def char
      super.to_s.downcase
    end

    def absolute?
      false
    end
  end
end
