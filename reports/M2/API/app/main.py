from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from resources.hikes import HikeResource, hikes
from models.models import db
import pandas as pd


def init_hike_list():
	mydata = pd.read_csv("stats.csv", engine='python')
	for i in range(len(mydata.ID)):

		newHike = Hike(hike_id =mydata.ID[i], name=mydata.Name[i], location=mydata.Location[i], difficulty=mydata.Difficulty[i],
			length=mydata.Length[i], gain=mydata.Gain[i], hiketype=mydata.Route[i],
			url=mydata.Link[i], img_1=mydata.img1[i], img_2=mydata.img2[i], img_3=mydata.img3[i],
			keywords=mydata.Keywords[i])
		hikes.append(newHike)

class Hike():
	def __init__(self, hike_id, name, location, difficulty, length, gain, hiketype, url, img_1, img_2, img_3, keywords):
		self.hike_id = hike_id
		self.name = name
		self.location = location
		self.difficulty = difficulty
		self.length = length
		self.gain = gain
		self.hiketype = hiketype
		self.url = url
		self.img_1 = img_1
		self.img_2 = img_2
		self.img_3 = img_3 
		self.keywords = keywords

	def get_json():
		return jsonify(newUser.username, newUser.distance_min, newUser.distance_max, newUser.elevation_min, newUser.elevation_max, 
				newUser.easy, newUser.medium, newUser.hard)

class User():
	def  __init__(self, username, distance_min, distance_max, elevation_min, elevation_max, easy, medium, hard):
		self.username = username
		self.distance_min = distance_min
		self.distance_max = distance_max
		self.elevation_min = elevation_min
		self.elevation_max = elevation_max
		self.easy = easy
		self.medium = medium
		self.hard = hard

init_hike_list()
app = Flask(__name__)
api = Api(app)

#Returns a hike and associated information, given a hike-id
api.add_resource(HikeResource, "/hike/<string:hike_id>")



#Model for how individual Hikes will be stored in the database.
#Hikes can be queried by the unique id.
#More to be added later, depending on image-classifier
if __name__ == "__main__":
	app.run(debug=True)