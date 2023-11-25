# frozen_string_literal: true

class RepresentativesController < ApplicationController
  def index
    @representatives = Representative.all
  end

  def show 
    @representative =  Representative.find_by(id: params[:id])
    if @representative == nil
      flash[:alert] = "There is no such Representative"
      redirect_to representatives_path
    else
      render :show
    end
  end

end
