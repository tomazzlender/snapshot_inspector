module ViewInspector
  class Snapshot
    class Type
      class_attribute :registry, default: {}, instance_writer: false, instance_predicate: false

      def self.snapshotee(class_name)
        registry[class_name] = self
      end

      def self.extract(snapshotee)
        record = new
        record.extract(snapshotee)
        record
      end

      def self.from_hash(hash)
        record = new
        record.from_hash(hash)
        record
      end

      def extract(_snapshotee)
        raise "Implement in a child class."
      end

      def from_hash(_hash)
        raise "Implement in a child class."
      end
    end
  end
end
