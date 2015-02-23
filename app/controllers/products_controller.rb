class ProductsController < ApplicationController
  # respond_to :html, :json

  def index
    respond_to do |format|
      format.html
      format.json { render json: ProductsDatatable.new(view_context) }
    end
  end

  private

  # xxx: this should go to lib/..
  class ProductsDatatable
    delegate :params, :h, :link_to, :number_to_currency, to: :@view

    def initialize(view)
      @view = view
    end

    def as_json(options = {})
      {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Product.count,
        iTotalDisplayRecords: products.total_entries,
        aaData: data
      }
    end

    private

    def data
      products.map do |product|
        [
          link_to(product.title, product),
          product.price
        ]
      end
    end

    def products
      @products ||= get_products
    end

    def get_products
      products = Product.order("#{sort_column} #{sort_direction}")
      products = products.page(page).per_page(per_page)
      if params[:sSearch].present?
        products = products.where("title like :q", q: "%#{params[:sSearch]}%")
      end
      products
    end

    def page
      params[:iDisplayStart].to_i / per_page + 1
    end

    def per_page
      (params[:iDisplayLength] || 10).to_i
    end

    def sort_column
      columns = %w[title price]
      columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end
  end
end
