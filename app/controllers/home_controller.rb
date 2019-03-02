class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  def index
    @advertisements = Advertisement.where(view_in_homepage: true).order('rank desc')
    @blogs = Blog.where(view_in_homepage: true).order('rank desc')
    if !params[:category_id].blank?
      @categories = Category.where(parent_id: params[:category_id]).order('rank desc')
    else
      @categories = Category.where(parent_id: nil).order('rank desc')
    end
  end
end
