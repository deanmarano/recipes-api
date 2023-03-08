require 'open-uri'

class JsonLdRecipe
  attr_reader :url, :user

  def initialize(url = 'https://www.sigsbeestreet.co/post/whole-wheat-chocolate-chip-cookies', user)
    @url = url
    @user = user
  end

  def script_ld_json_element
    self.html.xpath("//script")
      .find { |a| a.attributes["type"]&.value == "application/ld+json" }
  end

  def valid?
    self.script_ld_json_element.present?
  end

  def ld_json
    return @json if @json
    json = JSON.parse script_ld_json_element.text, symbolize_names: true
    @json = if json.is_a? Array
      json.find { |d| d[:@type]&.first == 'Recipe' || d[:@type] == 'Recipe' }
    elsif json.is_a? Hash
      json[:@graph]&.find { |a| a[:@type] == 'Recipe' } || json
    end
  end

  def name
    ld_json[:name]
  end

  def tagline
    ld_json[:description]
  end

  def servings
    ld_json[:yield]
  end

  def ingredients
    ld_json[:recipeIngredient]
  end

  def instructions
    ld_json[:recipeInstructions]
  end

  def cover_image_url
    image = ld_json[:image]
    if image.is_a? Hash
      image[:url]
    elsif image.is_a? Array
      if image.first.is_a? Hash
        image.first[:url]
      else
        image.first
      end
    else
      image
    end
  end

  def cover_image_alt
  end


  def cover_image_caption
  end

  def prep_time
    ld_json[:prepTime]
  end

  def cook_time
    ld_json[:cookTime]
  end

  def total_time
    ld_json[:totalTime]
  end

  def keywords
    ld_json[:keywords]
  end

  def recipe_category
    ld_json[:recipeCategory]
  end

  def nutrition
    ld_json[:nutrition]
  end

  def context
    ld_json[:@context]
  end

  def type
    ld_json[:@type]
  end

  def source_name
    element = self.html.xpath("//meta")
      .find { |a| a.attributes["property"]&.value == "og:site_name" }
    element.attributes["content"]&.value if element
  end

  def source_favicon_url
    element = self.html.xpath("//link")
      .find { |a| a.attributes["type"]&.value == "image/x-icon" }
    return element.attributes["href"]&.value if element
    element = self.html.xpath("//link")
      .find { |a| ["icon", "shortcut icon"].include? a.attributes["rel"]&.value }
    if element
      favicon_uri = URI.parse(element.attributes["href"]&.value)
      favicon_uri.hostname = uri.hostname if !favicon_uri.hostname
      favicon_uri.scheme = uri.scheme if !favicon_uri.scheme
      favicon_uri.to_s
    end

  end

  def uri
    URI.parse(self.url)
  end

  def slug
    self.uri.path.gsub(/^\/?/, "").gsub(/\/$/, '') ||
    self.url.gsub(/.*\//, '') || self.url[0..-2].gsub(/.*\//, '')
  end

  def recipe
    @recipe ||= Recipe.new
    @recipe.assign_attributes(
      user: user,
      source: url,
      slug: slug,
      url: url,
      cover_image_url: cover_image_url,
      cover_image_alt: cover_image_alt,
      cover_image_caption: cover_image_caption,
      servings: servings,
      name: name,
      tagline: tagline,
      instructions: instructions,
      ingredients: ingredients,
      source_name: source_name,
      source_favicon_url: source_favicon_url
    )
    @recipe
  end

  def html
    @html ||= page.live_html
  end

  def page
    @page ||= PageSnapshot.capture(self.url, self.user)
  end

  def other_recipes
    html.
      css("a").
      map { |a| a.attributes["href"]&.value }.
      compact.
      uniq.
      filter { |url| url.match /recipe\// }.
      map do |url|
        url = "https://bonappetit.com/" + url unless url.match "bonappetit"
        uri = URI(url)
        uri.fragment = nil
        BonAppetitRecipe.new(uri.to_s)
      end
  end
end
