module Menuseful
  module Item
    extend ActiveSupport::Concern

    included do
      helper_method :menu_item
    end

    module ClassMethods
      def menu_item(*args, &block)
        item_proc = block || proc { args }
        define_method :menu_item do
          @menu_item ||= Item.new(*instance_exec(&item_proc))
        end
      end
    end

    class Item
      attr_accessor :trail

      def initialize(*args)
        self.trail = args.flatten
      end

      def is?(*pattern_trail)
        raise ArgumentError, "Can't compare without any arguments." unless pattern_trail.present?
        trail.take(pattern_trail.length) == pattern_trail
      end
      alias_method :sub?, :is?

    end

    def menu_item
      Item.new
    end
  end
end
