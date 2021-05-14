from flask import Flask
from flask_restful import Api
from resources.hike_resource import HikeResource
from resources.user_resource import UserResource
from resources.review_resource import ReviewResource
from models import hikes, Hike
import pandas as pd

#Reads the hike data from stats.csv and intitializes "hikes" that contains all of the hikes and associated informaiton.
#Stores the information in global variable "hikes"
def init_hike_list():
	mydata = pd.read_csv("stats.csv", engine='python')
	for i in range(len(mydata.ID)):

		newHike = Hike(hike_id =mydata.ID[i], name=mydata.Name[i], rating=mydata.Rating[i], location=mydata.Location[i], difficulty=mydata.Difficulty[i],
			length=mydata.Length[i], gain=int(mydata.Gain[i].replace(",","")), hiketype=mydata.Route[i],
			url=mydata.Link[i], img_1=mydata.img1_url[i], img_2=mydata.img2_url[i], img_3=mydata.img3_url[i],
			keywords=mydata.Keywords[i])
		hikes.append(newHike)


init_hike_list()
app = Flask(__name__)
api = Api(app)

#Hike resource to get a recommended hike, given a username
api.add_resource(HikeResource, "/hike/<string:username>")
#User resource to create a user
api.add_resource(UserResource, "/user/<string:username>")
#Review resource for a user to leave a review
api.add_resource(ReviewResource, "/review/<string:username>")

#Model for how individual Hikes will be stored in the database.
#Hikes can be queried by the unique id.
#More to be added later, depending on image-classifier
if __name__ == "__main__":
	app.run(debug=True)