class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.all

    render json: @categories
  end

  # POST /categories
  def create
    @category = Category.new(name: params[:name])

    if @category.save
      render json: @category, status: :created
    else
      render json: {
        message: "gagal membuat kategori",
        errors: @category.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(name: params[:name])
      render json: @category
    else
      render json: {
        message: "gagal memperbarui kategori",
        errors: @category.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
  end

  private

  def set_category
    @category = Category.find(params[:id])
    if @category.nil?
      render json: {message: "Kategori tidak ditemukan"}
    end
  end
end
