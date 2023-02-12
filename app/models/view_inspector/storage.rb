module ViewInspector
  class Storage
    class << self
      def write(key, value)
        file_path = to_file_path(key)
        file_path.dirname.mkpath
        file_path.write(value)
      end

      def read(key)
        File.read(to_file_path(key))
      end

      def list
        Dir
          .glob("#{ViewInspector.configuration.absolute_storage_directory}/**/*.{json}")
          .map { |file_path| to_key(file_path) }
      end

      private

      def to_key(file_path)
        file_path.gsub(ViewInspector.configuration.absolute_storage_directory.to_s + "/", "").gsub(".json", "")
      end

      def to_file_path(key)
        ViewInspector.configuration.absolute_storage_directory.join("#{key}.json")
      end
    end
  end
end
