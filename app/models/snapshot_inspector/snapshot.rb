require "snapshot_inspector/snapshot/response_type"
require "snapshot_inspector/snapshot/mail_type"
require "snapshot_inspector/snapshot/test_unit_context"
require "snapshot_inspector/snapshot/rspec_context"

module SnapshotInspector
  class Snapshot
    class NotFound < StandardError; end

    class UnknownSnapshotee < StandardError; end

    attr_reader :snapshotee_class, :type, :context, :slug, :created_at
    delegate_missing_to :@data

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
        snapshot.context.order_identifier
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
      @snapshotee_class = snapshotee.class
      type_class = Type.registry[@snapshotee_class] || raise(UnknownSnapshotee.new(unknown_snapshotee_class_message))
      @data = type_class.extract(snapshotee)
      @type = type_class.to_s.underscore.split("/").last.gsub("_type", "")
    end

    def from_hash_type_specific_data(hash)
      @snapshotee_class = hash[:snapshotee_class].constantize
      @data = Type.registry[@snapshotee_class].from_hash(hash[:data])
      @type = @data.class.to_s.underscore.split("/").last.gsub("_type", "")
    end

    def from_hash_context(hash)
      @context = context_class(hash[:context][:test_framework].to_sym).from_hash(hash[:context])
    end

    def unknown_snapshotee_class_message
      "#take_snapshot only accepts an argument of kind #{Type.registry.keys.map(&:to_s).sort.map { |class_name| "`#{class_name}`" }.join(" or ")}. You provided `#{@snapshotee_class}`."
    end

    def extract_context(context)
      @context = context_class(context[:test_framework]).extract(context)
    end

    def context_class(test_framework)
      case test_framework
      when :test_unit then TestUnitContext
      when :rspec then RspecContext
      end
    end
  end
end
