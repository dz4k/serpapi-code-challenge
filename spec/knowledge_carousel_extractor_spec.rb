require "logger"
require "json"

require "knowledge_carousel_extractor"
require "util/uri"

describe KnowledgeCarouselExtractor, "#extract" do
  shared_examples "extract from file" do |file|
    before :all do
      uri = Util::URI::file_uri_from_path(file)
      @extractor = KnowledgeCarouselExtractor.new(logger: Logger.new($stdout))
      @result = @extractor.extract(uri, base_url: "https://www.google.com/search")
    end

    it "returns an array" do
      expect(@result).to be_an(Array)
    end

    it "returns knowledge carousel items" do
      expect(@result).to all(be_a(Hash))
      expect(@result[0]["name"]).to be_a(String)
      expect(@result[0]["link"]).to be_a(String)
      expect(@result[0]["link"]).to be_a_uri()
      expect(@result[0]["link"]).to have_uri_scheme("https")
      expect(@result[0]["image"]).to be_a_uri()
      expect(@result[0]["image"]).to have_uri_scheme("data")
      if @result[0].has_key?("extensions")
        expect(@result[0]["extensions"]).to be_an(Array)
        expect(@result[0]["extensions"]).to_not be_empty()
        expect(@result[0]["extensions"]).to all(be_a(String))
      end
    end
  end

  context "with query 'van gogh paintings'" do
    include_examples "extract from file", "files/van-gogh-paintings.html"
  end

  context "with query 'cities in alaska'" do
    include_examples "extract from file", "files/cities-in-alaska.html"
  end

  context "with query 'planets of the solar system'" do
    include_examples "extract from file", "files/planets-of-the-solar-system.html"
  end
end
