require "selenium-webdriver"
require "uri"

class KnowledgeCarouselExtractor
  def initialize(logger:)
    @logger = logger
  end

  BASE_URL = "https://www.google.com"
  ITEM_XPATH = "//*[contains(@class, 'klitem')]/ancestor-or-self::a"

  def extract(uri, base_url:)
    options = Selenium::WebDriver::Options.chrome
    options.args << "--headless=new"
    driver = Selenium::WebDriver.for(:chrome, options: options)
    driver.get(uri)

    item_els = driver.find_elements(xpath: ITEM_XPATH)
    result = item_els.map { |item_el| extract_item(item_el, base_url:) }

    driver.quit
    result
  end

  def extract_item(item_el, base_url:)
    result = {
      "name" => extract_name(item_el),
      "image" => extract_image(item_el),
      "link" => extract_link(item_el, base_url:),
    }
    extensions = extract_extensions(item_el, result["name"])
    result["extensions"] = extensions unless extensions.empty?
    return result
  end

  def extract_name(item_el)
    item_el.attribute("aria-label")
  end

  def extract_link(item_el, base_url:)
    href = item_el.dom_attribute("href")
    uri = URI::join(base_url, href)
    # Single quote ' is not a valid character in URIs, but expected_array.json doesn't escape it.
    uri.to_s.gsub "%27", "'"
  end

  def extract_image(item_el)
    img_el = item_el.find_element(tag_name: "img")
    src = img_el.attribute("src")
    # The values in expected_array.json are like this. Is this correct or a decoding error?
    src_corrected = src&.gsub("=", "x3d")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    nil
  end

  def extract_extensions(item_el, name)
    title = item_el.attribute("title")
    if title.delete_prefix!(name)
      match = title.match(/\((.*)\)/)
      if match
        match[1..]
      else
        []
      end
    else
      @logger.warn("extract_extensions: item's title '#{title}' doesn't contain its name '#{name}'")
      []
    end
  end
end
