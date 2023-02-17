module ViewInspector
  class Snapshots::MailRecordingsController < ApplicationController
    helper_method :part_query

    rescue_from Snapshot::NotFound, with: :snapshot_not_found

    def show
      @snapshot = Snapshot.find(params[:slug])
      @email = @snapshot.snapshotee_recording.message

      respond_to do |format|
        format.html do
          @part = find_preferred_part(request.format, Mime[:html], Mime[:text])
          render :show, layout: false
        end
        format.eml do
          send_data @email.to_s, filename: "#{@snapshot.snapshotee_recording.mailer_name}##{@snapshot.snapshotee_recording.action_name}.eml"
        end
      end
    end

    def raw
      @snapshot = Snapshot.find(params[:slug])
      @email = @snapshot.snapshotee_recording.message
      part_type = Mime::Type.lookup(params[:part])

      if (part = find_part(part_type))
        response.content_type = part_type
        render plain: part.respond_to?(:decoded) ? part.decoded : part
      else
        raise AbstractController::ActionNotFound, "Email part '#{part_type}' not found in a snapshot #{@snapshot.test.test_case_name}##{@snapshot.test.method_name}"
      end
    end

    private

    def find_preferred_part(*formats)
      formats.each do |format|
        if (part = @email.find_first_mime_type(format))
          return part
        end
      end
      if formats.any? { |f| @email.mime_type == f }
        @email
      end
    end

    def find_part(format)
      if (part = @email.find_first_mime_type(format))
        part
      elsif @email.mime_type == format
        @email
      end
    end

    def part_query(mime_type)
      request.query_parameters.merge(part: mime_type).to_query
    end
  end
end
