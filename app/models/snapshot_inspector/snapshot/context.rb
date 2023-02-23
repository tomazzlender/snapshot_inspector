module SnapshotInspector
  class Snapshot
    class Context
      class_attribute :registry, default: {}, instance_writer: false, instance_predicate: false

      def self.test_framework(name)
        registry[name] = self
      end

      def self.extract(context)
        record = registry[context[:test_framework]].new
        record.extract(context)
        record
      end

      def self.from_hash(hash)
        record = registry[hash[:test_framework].to_sym].new
        record.from_hash(hash)
        record
      end

      # @private
      def extract(_context)
        raise "Implement in a child class."
      end

      # @private
      def from_hash(_hash)
        raise "Implement in a child class."
      end

      def to_slug
        raise "Implement in a child class."
      end

      def name
        raise "Implement in a child class."
      end

      def test_group
        raise "Implement in a child class."
      end

      def order_index
        raise "Implement in a child class."
      end
    end
  end
end
