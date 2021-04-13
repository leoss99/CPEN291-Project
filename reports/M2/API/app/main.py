from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from resources.hikes import Hike, RandHike, AllHikes
from models.models import db

app = Flask(__name__)
api = Api(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
db.init_app(app)

with app.app_context():
	db.create_all()

#Returns a hike and associated information, given a hike-id
api.add_resource(Hike, "/hike/<string:hike_id>")
#Returns a random hike
api.add_resource(RandHike, "/randhike/")
#Returns a list of all hike
api.add_resource(AllHikes, "/allhikes/")

#Model for how individual Hikes will be stored in the database.
#Hikes can be queried by the unique id.
#More to be added later, depending on image-classifier
if __name__ == "__main__":
	app.run(debug=True)