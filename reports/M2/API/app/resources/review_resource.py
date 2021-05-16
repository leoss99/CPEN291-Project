from flask_restful import Resource, reqparse, abort, fields, marshal_with
import random
from flask import jsonify, request
from models import Hike, User, hikes, users
import json


resource_fields = {
	'username': fields.String,
	'hike_id': fields.String,
	'like': fields.String
	}

#review_put_args = reqparse.RequestParser()
#review_put_args.add_argument("hike_id", type=str, help="Hike ID required for review", required=True)
#review_put_args.add_argument("like", type=str, help="Like status required for review", required=True)

#review_get_args = reqparse.RequestParser()
#review_get_args.add_argument("hike_id", type=str, help="Hike ID required for review", required=True)

class ReviewResource(Resource):
	@marshal_with(resource_fields)
	def get(self, username):
		json_data = request.get_json(force=True)
		json_data = json.loads(json_data)
		hike_id = json_data['hike_id']
		review_user = [user for user in users if user.username == username]
		if len(review_user) == 0:
			abort(404, message="Could not find a user with that username")
		else:
			user = review_user[0]
			if hike_id in user.liked_hikes:
				liked = True
			elif hike_id in user.disliked_hikes:
				liked = False
			else:
				abort(404, message="Could not find that review")
		return jsonify({'username': username, 'hike_id': hike_id, 'like': liked})

	def post(self, username):
		json_data = request.get_json(force=True)
		json_data = json.loads(json_data)
		hike_id = json_data['hike_id']
		print(json_data['like'])
		print(json_data['hike_id'])
		if (json_data['like'] == 'True'):
			like = True
		else:
			like = False
		#Searches for associated user in user list
		review_user = [user for user in users if user.username == username]
		#Searches for associated hike in hike list
		review_hike = [hike for hike in hikes if hike.hike_id == hike_id]

		if len(review_user) == 0:
			abort(404, message="Could not find a user with that username")
		elif len(review_hike) == 0:
			abort(404, message="Could not find a hike with that hike ID")
		else:
			user = review_user[0]
			hike = review_hike[0]

		user.review_hike(hike, like)
		return 202
