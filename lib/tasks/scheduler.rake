namespace :get_booking_imformation do
  task :get_imformation => :environment do
    require "selenium-webdriver"
    require "date"

    SPORTS       = ["soccer", "futsal"]
    place_time   = {
      # soccerの場合、場所はにしじゅく未来公園
      "soccer" => {
        "place" => {2 => "多目的広場 (全面)", 3 => "多目的広場A面", 4 => "多目的広場B面"},
        "time" =>  {2 => "1回目 (6:00-8:00)", 3 => "2回目 (8:00-10:00)", 4 => "3回目 (10:00-12:00)", 5 => "4回目 (12:00-14:00)", 6 => "5回目 (14:00-16:00)", 7 => "6回目 (16:00-18:00)", 8 => "7回目 (18:00-20:00)"}
      },
      # futsalの場合、場所は小管西フットサル場
      "futsal" => {
        "place" => {2 => "フットサル場A", 3 => "フットサル場B"},
        "time" => {2 => "1回目 (8:00-10:00)", 3 => "2回目 (10:00-12:00)", 4 => "3回目 (12:00-14:00)", 5 => "4回目 (14:00-16:00)", 6 => "5回目 (16:00-18:00)", 7 => "6回目 (18:30-20:30)", 8 => "7回目 (20:30-22:30)"}
      } 
    }
    try_counts    = 0
    result        = []
    beginning_day = Date.today
    end_day       = Date.today.next_month.end_of_month
    holidays      = Holiday.where(date: beginning_day..end_day).map{ |holiday| holiday.date }

    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('headless')
    driver = Selenium::WebDriver.for :chrome, options: options

    begin
      SPORTS.each do |sports|
        go_to_calendor(driver, sports)
        month_counts = 0
        while month_counts < 2 do
          start_date = Date.today
          year = start_date.strftime("%Y").to_i
          month = start_date.strftime("%m").to_i
          day = start_date.strftime("%d").to_i
          days_in_month = start_date.end_of_month - start_date + 1
      
          # 日の予定確認画面へ
          driver.execute_script "window.selectDay((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWInstSrchVacantWAllAction, 1, #{year}, #{month}, #{day})"
          sleep(5.seconds)
          day_count = 0

          begin
            get_schedules(driver, result, place_time[sports]["place"], place_time[sports]["time"], holidays, start_date, day_count, days_in_month)
            # カレンダーに戻る
            driver.execute_script "window.doAction((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWInstSrchVacantBackWAllAction);"
            sleep(5.seconds)
            next_month = Date.today.next_month.to_s.gsub("-", "")[0..-3] + "01"
            # 翌月へ
            driver.execute_script "moveCalender((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWInstSrchMonthVacantWAllAction, #{next_month})"
            month_counts += 1
          rescue => e
            puts "counts: ", try_counts, " Error in get_schedule: ", e
            if try_counts < 10
              try_counts += 1
              driver.navigate.refresh
              sleep(2.seconds)
              retry
            else
              raise
            end
          end
        end
      end
      driver.quit
      if result.size > 0
        NotificationMailer.notification(result).deliver_now!
      end
    rescue => e
      puts "counts: ", try_counts, " Error in go_to_calender: ", e
      if try_counts < 10
        try_counts += 1
        driver.navigate.refresh
        sleep(2.seconds)
        retry
      else
        raise
      end
    end
  end

  def go_to_calendor(driver, sports)
    driver.navigate.to "https://rsv.shisetsu.city.katsushika.lg.jp/katsushika/web/index.jsp"
    sleep(5.seconds)

    # 施設の空き状況
    driver.execute_script "window.canLogin();"
    sleep(5.seconds)

    # 利用目的から
    driver.execute_script "window.doPpsdSearchAction((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchPpsdAction);"
    sleep(5.seconds)

    # 屋外スポーツ
    driver.execute_script "window.sendPpsdCd((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchPpsAction, '200','2');"
    sleep(5.seconds)

    if sports == "soccer"
      # サッカー
      driver.execute_script "window.doTransInstSrchBuildAction((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchBuildAction, '200' , '200300');"
      sleep(5.seconds)

      # にいじゅくみらい公園
      driver.execute_script "window.sendBldCd((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchInstAction, '503200');"
      sleep(5.seconds)
    elsif sports == "futsal"
      # フットサル
      driver.execute_script "doTransInstSrchBuildAction((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchBuildAction, '200' , '201100')"
      sleep(5.seconds)

      # 小管西フットサル場
      driver.execute_script "sendBldCd((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchInstAction, '503300')"
      sleep(5.seconds)
    end
  end

  def get_schedules(driver, result, place, time, holidays, start_date, day_count, days_in_month) 
    while day_count < days_in_month
      html = driver.page_source.encode('utf-8')
      page = Nokogiri::HTML(html)
      date = start_date + day_count

      (2..(place.length + 1)).to_a.each do |p|
        (2..(time.length + 1)).to_a.each do |t|
          alt = page.css("#disp > center > form > center > table > tbody > tr:nth-child(4) > td > table > tbody > tr > td:nth-child(1) > table > tbody > tr:nth-child(#{p}) > td:nth-child(#{t}) > img")[0]["alt"]
          if alt == "空き"
            # 土日祝 or ユーザーの指定した日付である場合、どこか一つでも空いてる時間があればresultに追加
            if !(date).workday? || HolidayJp.holiday?(date) || holidays.include?(date)
              result << "#{date}, #{place[p]}, #{time[t]}"
            elsif t == 8
              result << "#{date}, #{place[p]}, #{time[t]}"
            end
          end
        end
      end

      day_count += 1

      # 翌日へ
      driver.execute_script "doInstSrchVacantAction((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWInstSrchVacantWAllAction, 2, gSrchSelectInstNo, gSrchSelectInstMax);"
      sleep(5.seconds)
    end
  end
end
