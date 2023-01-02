class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :update, :destroy]

  # GET /recipes
  def index
    @recipes = Recipe.active

    render json: RecipeSerializer.new(@recipes).serialized_json
  end

  # GET /recipes/1
  def show
    render json: RecipeSerializer.new(@recipe).serialized_json
  end

  # POST /recipes
  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      render json: RecipeSerializer.new(@recipe).serialized_json, status: :created, location: @recipe
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1
  def update
    if @recipe.update(recipe_params)
      render json: RecipeSerializer.new(@recipe).serialized_json
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1
  def destroy
    if @recipe.archive!
      head :no_content
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  # POST /recipes/import
  def import
    recipe = JsonLdRecipe.new(params[:url]).recipe
    if recipe.save
      render json: RecipeSerializer.new(recipe).serialized_json
    else
      render json: recipe.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find_by(slug: params[:id]) || Recipe.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def recipe_params
      params.from_jsonapi.require(:recipe).permit(:slug, :name, :source, :status, :sha, :from_sha, :tagline, :ingredients, :instructions, images: [])
    end
end
