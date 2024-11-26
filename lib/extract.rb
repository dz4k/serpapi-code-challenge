require "logger"
require "json"

require_relative "knowledge_carousel_extractor"
require_relative "util/uri"

extractor = KnowledgeCarouselExtractor.new(logger: Logger.new($stderr))
file_uri = Util::URI::file_uri_from_path(ARGV[0])
result = extractor.extract(file_uri, base_url: "https://www.google.com/search")
puts JSON.dump({ "artworks" => result })
