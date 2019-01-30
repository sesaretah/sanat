class CategoriesController < ApplicationController
  before_action :check_user, only: [:change_rank, :create, :destroy]
  def change_rank
    @category = Category.find_by_uuid(params[:id])
    if params[:move] == 'up'
      @category.rank += 1
    else
      @category.rank -= 1
    end
    @category.save
    redirect_to '/'
  end

  def create
    if !params[:parent_id].blank?
      @parent = Category.where(uuid: params[:parent_id]).first.id
    else
      @parent = nil
    end
    @category = Category.create(title: params[:title], parent_id: @parent)
  end

  def destroy
    @category = Category.find(params[:id])
    if !@category.blank?
    @advertisements = Advertisement.where(category_id: @category.id)
    for advertisement in @advertisements
      advertisement.category_id = nil
      advertisement.save
    end
  end
    @category.destroy
  end

  def check_user
    if !grant_access("ability_to_change_categories", current_user)
      head(403)
    end
  end
end
