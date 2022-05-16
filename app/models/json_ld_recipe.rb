require 'open-uri'

class JsonLdRecipe
  attr_reader :url

  def initialize(url = 'https://www.sigsbeestreet.co/post/whole-wheat-chocolate-chip-cookies')
    @url = url
  end

  def script_ld_json_element
    self.page.xpath("//script")
      .find { |a| a.attributes["type"]&.value == "application/ld+json" }
  end

  def ld_json
    JSON.parse script_ld_json_element.text, symbolize_names: true
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
    ld_json[:image]
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

  def slug
    self.url.gsub(/.*\//, '')
  end

  def recipe
    @recipe ||= Recipe.new
    @recipe.assign_attributes(
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
      ingredients: ingredients
    )
    @recipe
  end

  def page
    @page ||= Nokogiri::HTML(URI.open(self.url))
  end

  def other_recipes
    page.
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
