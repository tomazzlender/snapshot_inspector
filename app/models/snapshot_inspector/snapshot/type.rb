module SnapshotInspector
  class Snapshot
    class Type
      class UnknownSnapshotee < StandardError; end

      class_attribute :registry, default: {}, instance_writer: false, instance_predicate: false

      def self.snapshotee(class_name)
        registry[class_name] = self
      end

      def self.extract(snapshotee)
        record = type_class(snapshotee.class).new
        record.extract(snapshotee)
        record
      end

      def self.from_hash(hash)
        record = type_class(hash[:snapshotee_class].constantize).new
        record.from_hash(hash)
        record
      end

      private_class_method def self.type_class(snapshotee_class)
        registry[snapshotee_class] || raise(UnknownSnapshotee.new(unknown_snapshotee_class_message(snapshotee_class)))
      end

      private_class_method def self.unknown_snapshotee_class_message(snapshotee_class)
        list_of_known_classes = registry.keys.map(&:to_s).sort.map { |class_name| "`#{class_name}`" }.join(" or ")
        "#take_snapshot only accepts an argument of kind #{list_of_known_classes}. You provided `#{snapshotee_class}`."
      end

      def type
        self.class.to_s.underscore.split("/").last.gsub("_type", "")
      end

      def extract(_snapshotee)
        raise "Implement in a child class."
      end

      def from_hash(_hash)
        raise "Implement in a child class."
      end

      def as_json(data = {})
        {snapshotee_class: registry.key(self.class)}.merge(super)
      end
    end
  end
end
