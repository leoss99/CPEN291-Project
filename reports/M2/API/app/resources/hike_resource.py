from flask_restful import Resource, reqparse, abort, fields, marshal_with
import random
from flask import jsonify
from models import Hike, User, hikes, users

resource_fields = {
	'hike_id': fields.String,
	'name': fields.String,
	'rating': fields.String,
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

class HikeResource(Resource):
	@marshal_with(resource_fields)
	def get(self, username):
		userlist = [user for user in users if user.username == username]
		if len(userlist) == 0:
			abort(404, message="Could not find a user with that username")
		else:
			hike_dicts = []
			hike_dicts = userlist[0].get_recommended_hikes()
			print(len(hike_dicts))
		return hike_dicts

