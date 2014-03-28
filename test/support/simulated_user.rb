module Support
  class SimulatedUser
    class Proxy
      def initialize(target)
        @target = target
      end

      def method_missing(*a, &b)
        @target.send(*a, &b)
        self
      end
    end

    def self.new(browser)
      Proxy.new(super)
    end

    def initialize(browser)
      @browser = browser
    end

    private

    def browser(&block)
      @browser.instance_eval(&block)
    end
  end
end
