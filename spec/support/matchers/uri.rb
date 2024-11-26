RSpec::Matchers.define :be_a_uri do |expected|
  # https://gist.github.com/SirRawlins/8956101?permalink_comment_id=3293674#gistcomment-3293674
  match do |actual|
    actual =~ URI::DEFAULT_PARSER.make_regexp
  end
end

RSpec::Matchers.define :have_uri_scheme do |expected|
  match do |actual|
    uri = URI::parse actual
    uri.scheme == expected
  end
end
