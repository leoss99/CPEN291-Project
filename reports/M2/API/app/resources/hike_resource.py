from flask_restful import Resource, reqparse, abort, fields, marshal_with
import random
from flask import jsonify, request
from models import Hike, User, hikes, users
import json

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
	def get(self, username):
		userlist = [user for user in users if user.username == username]
		if len(userlist) == 0:
			abort(404, message="Could not find a user with that username")
		else:
			hike_dicts = []
			hike_recs = userlist[0].get_recommended_hikes()
			for hike in hike_recs:
				hike_dicts.append({'hike_id' : hike.hike_id, 'name': hike.name, 'rating' : hike.rating, 'location': hike.location,
					'difficulty' : hike.difficulty, 'length' : hike.length, 'gain' : hike.gain, 'hiketype' : hike.hiketype,
					'url' : hike.url, 'img_1' : hike.img_1, 'img_2' : hike.img_2, 'img_3' : hike.img_3, 'keywords' : hike.keywords})
		return jsonify(hike_dicts)

