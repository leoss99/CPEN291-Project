from flask_restful import Resource, reqparse, abort, fields, marshal_with
from models.models import HikeModel, db
import random
from sqlalchemy import func

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
hike_put_args.add_argument("location", type=str, help="Location of the hike required", required=True)
hike_put_args.add_argument("difficulty", type=str, help="Difficulty of the hike required", required=True)
hike_put_args.add_argument("length", type=float, help="Length of the hike required", required=True)
hike_put_args.add_argument("gain", type=int, help="Gain of the hike required", required=True)
hike_put_args.add_argument("hiketype", type=str, help="Hike-type of the hike required", required=True)
hike_put_args.add_argument("url", type=str, help="URL of the hike required", required=True)
hike_put_args.add_argument("img_1", type=str, help="Name of image 1 required", required=True)
hike_put_args.add_argument("img_2", type=str, help="Name of image 2 required", required=True)
hike_put_args.add_argument("img_3", type=str, help="Name of image 3 required", required=True)
hike_put_args.add_argument("keywords", type=str, help="Keywords required", required=True)

class Hike(Resource):
	@marshal_with(resource_fields)
	def get(self, hike_id):
		result = HikeModel.query.filter_by(hike_id=hike_id).first()
		if not result:
			abort(404, message="Could not find hike with that ID")
		return result

	@marshal_with(resource_fields)
	def put(self, hike_id):
		args = hike_put_args.parse_args()
		result = HikeModel.query.filter_by(hike_id=hike_id).first()
		if result:
			abort(409, message="Hike ID taken...")
		hike = HikeModel(hike_id=hike_id, name=args['name'], location=args['location'], difficulty=args['difficulty'], length=args['length'], gain=args['gain'], hiketype=args['hiketype'], url=args['url'], img_1=args['img_1'], img_2=args['img_2'], img_3=args['img_3'], keywords=args['keywords'])
		db.session.add(hike)
		db.session.commit()
		return hike, 201

class RandHike(Resource):
	@marshal_with(resource_fields)
	def get(self):
		result = HikeModel.query.order_by(func.random()).first()
		if not result:
			abort(404, message="Could not find hike.")
		return result

class AllHikes(Resource):
	@marshal_with(resource_fields)
	def get(self):
		result = HikeModel.query.all()
		if not result:
			abort(404, message="Could not retrieve all hikes.")
		return result