module SnapshotInspector
  class Snapshot
    class TestUnitContext
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

      def test_group
        test_case_name
      end

      def order_index
        source_location.dup << take_snapshot_index
      end

      def name
        method_name.gsub(/^test_/, "").humanize(capitalize: false)
      end

      def to_slug
        spec_path_without_extension = source_location[0].delete_suffix(File.extname(source_location[0])).delete_prefix(Rails.root.to_s + "/")
        [spec_path_without_extension, source_location[1], take_snapshot_index].join("_")
      end
    end
  end
end
