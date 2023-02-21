module SnapshotInspector
  module Test
    module ActionMailerHeaders
      extend ActiveSupport::Concern

      included do
        before_action :snapshot_inspector_headers, if: -> { Rails.env.test? }
      end

      private

      def snapshot_inspector_headers
        headers["X-SnapshotInspector-Mailer-Name"] = mailer_name
        headers["X-SnapshotInspector-Action-Name"] = action_name
      end
    end
  end
end
