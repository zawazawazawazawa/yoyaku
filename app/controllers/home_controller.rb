class HomeController < ApplicationController
  def index
    @holidays = Holiday.all
  end
end