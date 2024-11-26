module Util
  module URI
    def self.file_uri_from_path(path)
      ::URI::join("file:///", File.absolute_path(path))
    end
  end
end
