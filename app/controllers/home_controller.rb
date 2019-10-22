class HomeController < ApplicationController
  def index
    # todo: 今月、翌月、翌々月に絞りたい
    start_date = Date.today
    end_date = Date.today.next_month.next_month.at_end_of_month
    @holidays = Holiday.where(date: start_date..end_date)
    @users = User.all
  end
end