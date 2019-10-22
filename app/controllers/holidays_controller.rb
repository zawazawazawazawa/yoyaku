class HolidaysController < ApplicationController
  def new
    @holiday = Holiday.new
  end

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      redirect_to root_path
    else
      render new_holidays_path
    end
  end
  
  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy
    redirect_to root_path
  end

  private
    def holiday_params
      params.require(:holiday).permit(:date)
    end

end
