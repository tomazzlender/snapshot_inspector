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
        @example[:example_group][:parent_example_group][:description]
      end

      def order_identifier
        "#{@example[:location]}:#{@take_snapshot_index}"
      end

      def name
        @example[:full_description].gsub(test_group, "").strip
      end

      def to_slug
        @example[:full_description].underscore.tr(" ", "_") + "_" + @take_snapshot_index.to_s
      end
    end
  end
end
