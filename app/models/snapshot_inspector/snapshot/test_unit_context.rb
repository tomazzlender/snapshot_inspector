module SnapshotInspector
  class Snapshot
    class TestUnitContext
      # Name `:take_snapshot_index` could be improve. It represents: if two snapshots are taken in a single test, they will have indexes 0 and 1.
      attr_reader :test_framework, :test_case_name, :method_name, :source_location, :take_snapshot_index

      def self.extract(context)
        new.extract(context)
      end

      def self.from_hash(hash)
        new.from_hash(hash)
      end

      def extract(context)
        @test_framework = context[:test_framework]
        @test_case_name = context[:test_case_name]
        @method_name = context[:method_name]
        @source_location = context[:source_location]
        @take_snapshot_index = context[:take_snapshot_index]
        self
      end

      def from_hash(hash)
        @test_framework = hash[:test_framework].to_sym
        @test_case_name = hash[:test_case_name]
        @method_name = hash[:method_name]
        @source_location = hash[:source_location]
        @take_snapshot_index = hash[:take_snapshot_index]
        self
      end

      def name
        method_name.gsub(/^test_/, "").humanize(capitalize: false)
      end

      def to_slug
        [test_case_name.underscore, "#{method_name}_#{take_snapshot_index}"].join("/")
      end
    end
  end
end
