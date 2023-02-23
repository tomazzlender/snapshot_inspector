require "snapshot_inspector/snapshot/response_type"
require "snapshot_inspector/snapshot/mail_type"
require "snapshot_inspector/snapshot/test_unit_context"
require "snapshot_inspector/snapshot/rspec_context"

module SnapshotInspector
  class Snapshot
    class NotFound < StandardError; end

    attr_reader :context, :slug, :created_at
    delegate_missing_to :@type_data

    def self.persist(snapshotee:, context:)
      new.extract(snapshotee: snapshotee, context: context).persist
    end

    def self.find(slug)
      hash = JSON.parse(Storage.read(slug), symbolize_names: true)
      new.from_hash(hash)
    rescue Errno::ENOENT
      raise NotFound.new("Snapshot with a slug `#{slug}` can't be found.")
    end

    def self.grouped_by_test_case
      all.group_by do |snapshot|
        snapshot.context.test_group
      end
    end

    private_class_method def self.all
      snapshots = Storage.list.map { |slug| find(slug) }

      order_by_line_number(snapshots)
    end

    private_class_method def self.order_by_line_number(snapshots)
      snapshots.sort_by do |snapshot|
        snapshot.context.order_index
      end
    end

    def extract(snapshotee:, context:)
      extract_type_specific_data(snapshotee)
      extract_context(context)

      @slug = @context.to_slug
      @created_at = Time.current
      self
    end

    def persist
      Storage.write(slug, JSON.pretty_generate(as_json))
      self
    end

    def from_hash(hash)
      from_hash_type_specific_data(hash)
      from_hash_context(hash)

      @slug = hash[:slug]
      @created_at = Time.zone.parse(hash[:created_at])
      self
    end

    private

    def extract_type_specific_data(snapshotee)
      @type_data = Type.extract(snapshotee)
    end

    def extract_context(context)
      @context = Context.extract(context)
    end

    def from_hash_type_specific_data(hash)
      @type_data = Type.from_hash(hash[:type_data])
    end

    def from_hash_context(hash)
      @context = Context.from_hash(hash[:context])
    end
  end
end
