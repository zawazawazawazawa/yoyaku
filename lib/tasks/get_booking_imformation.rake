namespace :get_booking_imformation do
  task :sample do
    require "selenium-webdriver"

    wait = Selenium::WebDriver::Wait.new(timeout: 30)

    driver = Selenium::WebDriver.for :chrome
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

    # # サッカー
    # driver.execute_script "window.doTransInstSrchBuildAction((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchBuildAction, '200' , '200300');"
    # sleep(5.seconds)

    # # にいじゅくみらい公園
    # driver.execute_script "window.sendBldCd((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchInstAction, '503200');"
    # sleep(5.seconds)
    
    
    # フットサル
    driver.execute_script "window.doTransInstSrchBuildAction((_dom == 3) ? document.layers['disp'].document.form1 : document.form1, gRsvWTransInstSrchBuildAction, '200' , '201100');"
    sleep(5.seconds)

    # 小管西フットサル場
    driver.find_element(:css, '#disp > center > form > table:nth-child(16) > tbody > tr:nth-child(4) > td:nth-child(3) > a > img').click
    sleep(5.seconds)




    # # 施設の空き状況
    # wait.until { driver.find_element(:css, '#disp > center > form > table:nth-child(5) > tbody > tr:nth-child(1) > td > table > tbody > tr:nth-child(2) > td:nth-child(1) > table > tbody > tr:nth-child(2) > td > a > img').displayed? }
    # driver.find_element(:css, '#disp > center > form > table:nth-child(5) > tbody > tr:nth-child(1) > td > table > tbody > tr:nth-child(2) > td:nth-child(1) > table > tbody > tr:nth-child(2) > td > a > img').click
    
    # # 利用目的から
    # wait.until { driver.find_element(:css, '#disp > center > form > table:nth-child(6) > tbody > tr:nth-child(3) > td > a > img').displayed? }
    # driver.find_element(:css, '#disp > center > form > table:nth-child(6) > tbody > tr:nth-child(3) > td > a > img').click
    
    # # 屋外スポーツ
    # wait.until { driver.find_element(:css, '#disp > center > form > table.tcontent > tbody > tr:nth-child(1) > td:nth-child(2) > a > img').displayed? }
    # driver.find_element(:css, '#disp > center > form > table.tcontent > tbody > tr:nth-child(1) > td:nth-child(2) > a > img').click

    # # # 以下サッカーとフットサルの２パターンに別れる
    # # # サッカー
    # # wait.until { driver.find_element(:css, '#disp > center > form > table:nth-child(17) > tbody > tr:nth-child(1) > td:nth-child(4) > a > img').displayed? }
    # # driver.find_element(:css, '#disp > center > form > table:nth-child(17) > tbody > tr:nth-child(1) > td:nth-child(4) > a > img').click
    
    # # # にいじゅくみらい公園
    # # wait.until { driver.find_element(:css, '#disp > center > form > table:nth-child(16) > tbody > tr:nth-child(3) > td:nth-child(2) > a > img').displayed? }
    # # driver.find_element(:css, '#disp > center > form > table:nth-child(16) > tbody > tr:nth-child(3) > td:nth-child(2) > a > img').click

    # # フットサル
    # wait.until { driver.find_element(:css, '#disp > center > form > table:nth-child(17) > tbody > tr:nth-child(3) > td:nth-child(4) > a > img').displayed? }
    # driver.find_element(:css, '#disp > center > form > table:nth-child(17) > tbody > tr:nth-child(3) > td:nth-child(4) > a > img').click

    # # 小菅西フットサル場
    # wait.until { driver.find_element(:css, '#disp > center > form > table:nth-child(16) > tbody > tr:nth-child(4) > td:nth-child(3) > a > img').displayed? }
    # driver.find_element(:css, '#disp > center > form > table:nth-child(16) > tbody > tr:nth-child(4) > td:nth-child(3) > a > img').click

    sleep(5.seconds)
    driver.quit
  end
end
