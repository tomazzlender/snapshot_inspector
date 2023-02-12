module ViewInspector
  class Storage
    class << self
      def write(key, value)
        file_path = to_file_path_for_writing(key)
        file_path.dirname.mkpath
        file_path.write(value)
      end

      def read(key)
        File.read(to_file_path_for_reading(key))
      end

      def list
        Dir
          .glob("#{snapshots_directory}/**/*.{json}")
          .map { |file_path| to_key(file_path) }
      end

      def snapshots_directory
        ViewInspector.configuration.storage_directory.join("snapshots")
      end

      def processing_directory
        ViewInspector.configuration.storage_directory.join("processing")
      end

      def clear(directory = nil)
        case directory
        when :snapshots
          snapshots_directory.rmtree
        when :processing
          processing_directory.rmtree
        else
          snapshots_directory.rmtree
          processing_directory.rmtree
        end
      end

      def move_files_from_processing_directory_to_snapshots_directory
        clear(:snapshots)
        processing_directory.rename(snapshots_directory)
      end

      private

      def to_key(file_path)
        file_path.gsub(snapshots_directory.to_s + "/", "").gsub(".json", "")
      end

      def to_file_path_for_reading(key)
        snapshots_directory.join("#{key}.json")
      end

      def to_file_path_for_writing(key)
        processing_directory.join("#{key}.json")
      end
    end
  end
end
