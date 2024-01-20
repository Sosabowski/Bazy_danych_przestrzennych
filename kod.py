import requests

url = 'http://DESKTOP-FM9SSSA/fmedatadownload/cw12/shapefile2tiff.fmw?email=wespepolskistudios%40gmail.com&password=aaa&email_klient=wespepolskistudios%40gmail.com&data_poczatek=20230706000000&data_koniec=20230731000000&chmury=20&powiat=Kielce&API_key=5ac136f1-42c9-4e52-b80b-3216b778c110&SourceDataset_SHAPEFILE=D%3A%5Cpowiaty%5Cpowiaty.shp&DestDataset_TIFF=D%3A%5Cpowiaty&opt_showresult=false&opt_servicemode=sync'
myobj = {'Authorization': 'fmetoken token=eb333315d80cbdddc28d6604bcd466a735403f40'}

x = requests.post(url, headers = myobj)

print(x.text)
