from flask_restful import Resource, reqparse, abort, fields, marshal_with
from models.models import HikeModel
import random
from sqlalchemy import func

hikes = []

##from main import SQLAlchemy, Resource, fields, abort, marshal_with, reqparse
##from requests import *


#Model for how individual Hikes will be stored in the database.
#Hikes can be queried by the unique id.
#More to be added later, depending on image-classifier

resource_fields = {
	'hike_id': fields.String,
	'name': fields.String,
	'location': fields.String,
	'difficulty': fields.String,
	'length': fields.Float,
	'gain': fields.Float,
	'hiketype': fields.String,
	'url': fields.String,
	'img_1': fields.String,
	'img_2': fields.String,
	'img_3': fields.String,
	'keywords': fields.String
	}

hike_put_args = reqparse.RequestParser()
hike_put_args.add_argument("name", type=str, help="Name of the hike required", required=True)
hike_get_args = reqparse.RequestParser()
hike_get_args.add_argument("hike_id", type=str, help="Hike_id required", required=True)

class HikeResource(Resource):
	@marshal_with(resource_fields)
	def get(self, hike_id):
		retval = [hike for hike in hikes if hike.hike_id == hike_id]
		if len(retval) is 0:
			abort(404, message="Could not find a hike with that name")
		else:
			return retval[0]

