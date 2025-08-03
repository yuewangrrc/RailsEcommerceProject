class PagesController < ApplicationController
  def show
    @page = Page.find_by_slug(params[:slug])
    
    if @page.nil?
      redirect_to root_path, alert: "Page not found"
      return
    end
    
    @categories = Category.all
  end
end
