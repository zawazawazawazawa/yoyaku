class HolidaysController < ApplicationController
  def index
    # todo: 今月、翌月、翌々月に絞りたい
    @holidays = Holiday.all
  end

  def new
    @holiday = Holiday.new
  end

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      redirect_to holiays_path
    else
      render new_holidays_path
    end
  end
  
  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy
    redirect_to holidays_path
  end

  private
    def holiday_params
      params.require(:holiday).permit(:date)
    end

end
