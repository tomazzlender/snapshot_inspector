module ViewInspector
  module Test
    module ActionMailerHeaders
      extend ActiveSupport::Concern

      included do
        before_action :view_inspector_headers, if: -> { Rails.env.test? }
      end

      private

      def view_inspector_headers
        headers["X-ViewInspector-Mailer-Name"] = mailer_name
        headers["X-ViewInspector-Action-Name"] = action_name
      end
    end
  end
end
