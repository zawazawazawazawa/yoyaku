class HomeController < ApplicationController
  def index
    # todo: 今月、翌月、翌々月に絞りたい
    @holidays = Holiday.all
    @users = User.all
  end
end