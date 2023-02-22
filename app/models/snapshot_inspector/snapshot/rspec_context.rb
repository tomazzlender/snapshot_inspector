module SnapshotInspector
  class Snapshot
    class RspecContext
      # Name `:take_snapshot_index` could be improve. It represents: if two snapshots are taken in a single test, they will have indexes 0 and 1.
      attr_reader :test_framework, :example, :take_snapshot_index

      def self.extract(context)
        new.extract(context)
      end

      def self.from_hash(hash)
        new.from_hash(hash)
      end

      def extract(context)
        @test_framework = context[:test_framework]
        @example = context[:example]
        @take_snapshot_index = context[:take_snapshot_index]
        self
      end

      def from_hash(hash)
        @test_framework = hash[:test_framework].to_sym
        @example = hash[:example]
        @take_snapshot_index = hash[:take_snapshot_index]
        self
      end

      def test_group
        root_example_group_description(@example)
      end

      def order_index
        [@example[:file_path], @example[:line_number], @take_snapshot_index]
      end

      def name
        @example[:full_description].gsub(test_group, "").strip
      end

      def to_slug
        spec_path_without_extension = @example[:file_path].delete_suffix(File.extname(@example[:file_path])).delete_prefix("./")
        [spec_path_without_extension, @example[:line_number], @take_snapshot_index].join("_")
      end

      private

      def root_example_group_description(hash)
        if hash[:example_group].present?
          root_example_group_description(hash[:example_group])
        elsif hash[:parent_example_group].present?
          root_example_group_description(hash[:parent_example_group])
        else
          hash[:description]
        end
      end
    end
  end
end
