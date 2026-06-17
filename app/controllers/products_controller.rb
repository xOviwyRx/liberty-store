class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @query     = params[:q]
    @in_stock  = params[:in_stock].present?
    @min_price = params[:min_price]
    @max_price = params[:max_price]

    @products = Product.search(@query)
    @products = @products.in_stock if @in_stock
    @products = @products.priced_from(@min_price) if @min_price.present?
    @products = @products.priced_up_to(@max_price) if @max_price.present?
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
  def product_params
    params.expect(product: [ :name, :description, :featured_image, :inventory_count, :price ])
  end
end
