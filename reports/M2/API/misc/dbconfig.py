import pandas as pd
import requests
BASE = "http://127.0.0.1:5000/"

#In this file I will initialize the database that holds individual hike information and convert the .csv file.
mydata = pd.read_csv("stats.csv", engine='python')
for i in range(len(mydata.ID)):
	arg = {'name': mydata.Name[i], 'location': mydata.Location[i], 'difficulty': mydata.Location[i],
			'length': mydata.Length[i], 'gain': mydata.Gain[i], 'hiketype': mydata.Route[i],
			'url': mydata.Link[i], 'img_1': mydata.img1[i], 'img_2': mydata.img2[i], 'img_3': mydata.img3[i],
			'keywords': mydata.Keywords[i]}

	response = requests.put(BASE + "hike/" + mydata.ID[i], arg)
	#Check if response correctly added
	response = requests.get(BASE + "hike/" + mydata.ID[i])