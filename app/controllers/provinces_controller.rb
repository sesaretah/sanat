class ProvincesController < ApplicationController

  def create
    @province = Province.create(name: params[:name])
  end

  def destroy
    @province = Province.find(params[:id])
    @province.destroy
  end
end
