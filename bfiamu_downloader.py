import requests
import csv
import time

headers = {'user-agent': 'Mozilla/6.0 (Macintosh; Intel Mac OS X 10_14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.2785.143 Safari/537.36'}
write_path = '/Users/david/desktop/CSVData/'
for year in range(2020, 2021):
	for month in range(1, 13):
		if month % 2 == 1:
			max_date = 32
		else:
			if month == 2:
				max_date = 29
			else:
				max_date = 31

		for date in range(1, max_date):
			try:
			# 當for loop的日期超過今天就停止執行腳本
				today_date = datetime.today().strftime('%Y%m%d')
				current_file_date = '{}{:02d}{:02d}'.format(year, month, date)
				if int(today_date) < int(current_file_date):
					print('Finish runing the script :)')
					break

				check_url = 'https://www.twse.com.tw/exchangeReport/BFIAMU?response=csv&date={}{:02d}{:02d}'.format(year, month, date)
				print('Accessing URL:', check_url)
				r = requests.get(check_url)
				if r.status_code == 200:
					if r.content == b'\r\n':
						print('Ignore saving blank csv file')
					else:
						with open(check_url[-8:]+'.csv', 'wb') as file:
							file.writelines(r)
					time.sleep(3)
					print('Delay 3 seconds...')
				else:
					print('Request Error!')
			except Exception as ex:
			    print(str(ex))
			    exit(0)
