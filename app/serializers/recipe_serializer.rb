class RecipeSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :dash
  set_id :slug

  attributes(
    :name,
    :source,
    :status,
    :sha,
    :ingredients,
    :instructions,
    :parent_id,
    :created_at,
    :tagline,
    :cover_image_url,
    :cover_image_alt,
    :cover_image_caption,
    :servings,
    :source_name,
    :source_favicon_url
  )
end
