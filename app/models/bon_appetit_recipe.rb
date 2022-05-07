require 'open-uri'

class BonAppetitRecipe
  attr_reader :url

  def initialize(url = 'https://www.bonappetit.com/recipe/crispy-tofu-with-maple-soy-glaze')
    @url = url
  end

  def name
    page.at_css('h1').text
  end

  def tagline
    page.at_css('h2').text
  end

  def servings
    page.at_css('.post-dek-meta').text
  end

  def ingredients
    page.css('.ingredients li.ingredient').map do |ingredient_node|
      ingredient_node.text
    end
  end

  def instructions
    page.css('.steps li.step').map do |step_node|
      step_node.text
    end
  end

  def cover_image_url
    page.at_css('img.ba-picture--fit').attribute('srcset').value.split('1x,')[1].split(' ')[0]
  end

  def cover_image_alt
    page.at_css('img.ba-picture--fit').attribute('alt').value
  end


  def cover_image_caption
    page.at_css("figcaption cite")&.text
  end

  def slug
    self.url.gsub(/.*\//, '')
  end

  def recipe
    @recipe ||= Recipe.new
    @recipe.assign_attributes(
      source: url,
      slug: slug,
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
    @page ||= Nokogiri::HTML(open(self.url))
  end
end
