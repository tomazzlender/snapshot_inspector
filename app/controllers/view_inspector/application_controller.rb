module ViewInspector
  class ApplicationController < ActionController::Base
    content_security_policy(false)

    private

    def snapshot_not_found(error)
      @error = error
      render "view_inspector/snapshots/not_found", status: 404
    end
  end
end
