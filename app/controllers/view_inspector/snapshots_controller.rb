module ViewInspector
  class SnapshotsController < ApplicationController
    helper_method :part_query

    content_security_policy(false)

    def index
      @grouped_by_test_class = Snapshot.grouped_by_test_case
    end

    def show
      @snapshot = Snapshot.find(params[:slug])

      show_mail_recording if @snapshot.snapshotee_recording_klass == ViewInspector::Snapshot::MailRecording
    end

    def show_mail_recording
      @email = @snapshot.snapshotee_recording.message
      if params[:part]
        part_type = Mime::Type.lookup(params[:part])

        if (part = find_part(part_type))
          response.content_type = part_type
          render plain: part.respond_to?(:decoded) ? part.decoded : part
        else
          raise AbstractController::ActionNotFound, "Email part '#{part_type}' not found in a snapshot #{@snapshot.test.test_case_name}##{@snapshot.test.method_name}"
        end
      elsif params[:format] == "eml"
        send_data @email.to_s, filename: "#{@snapshot.snapshotee_recording.action_name}.eml"
      else
        @part = find_preferred_part(request.format, Mime[:html], Mime[:text])
        render :show, layout: false, formats: [:html]
      end
    end

    def raw
      @snapshot = Snapshot.find(params[:slug])
      render :raw, layout: false
    rescue Snapshot::NotFound => error
      @error = error
      render :not_found, status: 404
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
