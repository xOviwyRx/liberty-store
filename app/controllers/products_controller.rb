class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.search(filter_params[:query])
    @products = @products.in_stock if filter_params[:in_stock]
    @products = @products.priced_from(filter_params[:min_price]) if filter_params[:min_price].present?
    @products = @products.priced_up_to(filter_params[:max_price]) if filter_params[:max_price].present?
    @products = @products.sorted(filter_params[:sort]).with_attached_featured_image
    @pagy, @products = pagy(@products)
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

  def filter_params
    @filter_params ||= {
      query: params[:q],
      in_stock: params[:in_stock].present?,
      min_price: params[:min_price],
      max_price: params[:max_price],
      sort: params[:sort]
    }
  end
end
