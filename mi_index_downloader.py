import requests
import csv
import time
from datetime import datetime

# headers = {'user-agent': 'Mozilla/6.0 (Macintosh; Intel Mac OS X 10_14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.2785.143 Safari/537.36'}
# write_path = '/Users/david/mi_index_csv/'
# for year in range(2020, 2021):
# 	for month in range(1, 13):
# 		if month % 2 == 1:
# 			max_date = 32
# 		else:
# 			if month == 2:
# 				max_date = 29
# 			else:
# 				max_date = 31

# 		for date in range(1, max_date):
# 			for type_num in range(1, 32):
# 				try:
# 					today_date = datetime.today().strftime('%Y%m%d')
# 					current_file_date = '{}{:02d}{:02d}'.format(year, month, date)
# 					if int(today_date) < int(current_file_date):
# 						print('Finish runing the script :)')
# 						break

# 					check_url = 'https://www.twse.com.tw/exchangeReport/MI_INDEX?response=csv&date={}{:02d}{:02d}&type={:02d}'.format(year, month, date, type_num)
# 					print('Accessing URL:', check_url)
# 					r = requests.get(check_url)
# 					target_save_csv = 'MI-INDEX-{:02d}-{}.csv'.format(type_num, check_url[-16:-8])

# 					if r.status_code == 200:
# 						if r.content == b'\r\n' or r.content == b'':
# 							print('Ignore blank csv file [{}]'.format(target_save_csv))
# 						else:
# 							with open(target_save_csv, 'wb') as file:
# 								file.writelines(r)
# 						time.sleep(3)
# 						print('Delay 3 seconds...')
# 					else:
# 						print('Request Error!')
# 				except Exception as ex:
# 				    print(str(ex))
# 				    exit(0)


headers = {'user-agent': 'Mozilla/6.0 (Macintosh; Intel Mac OS X 10_14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.2785.143 Safari/537.36'}
write_path = '/Users/david/mi_index_csv/'
for type_num in range(1, 32):
	try:
		today_date = datetime.today().strftime('%Y%m%d')
		check_url = 'https://www.twse.com.tw/exchangeReport/MI_INDEX?response=csv&date={}&type={:02d}'.format(today_date, type_num)
		print('Accessing URL:', check_url)
		r = requests.get(check_url)
		target_save_csv = 'MI-INDEX-{:02d}-{}.csv'.format(type_num, today_date)

		if r.status_code == 200:
			if r.content == b'\r\n' or r.content == b'':
				print('Ignore blank csv file [{}]'.format(target_save_csv))
			else:
				with open(target_save_csv, 'wb') as file:
					file.writelines(r)
			time.sleep(3)
			print('Delay 3 seconds...')
		else:
			print('Request Error!')
	except Exception as ex:
	    print(str(ex))
	    exit(0)
