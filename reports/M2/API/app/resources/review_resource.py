from flask_restful import Resource, reqparse, abort, fields, marshal_with
import random
from flask import jsonify
from models import Hike, User, hikes, users


resource_fields = {
	'username': fields.String,
	'hike_id': fields.String,
	'like': fields.Boolean
	}

review_put_args = reqparse.RequestParser()
review_put_args.add_argument("hike_id", type=str, help="Hike ID required for review", required=True)
review_put_args.add_argument("like", type=bool, help="Like status required for review", required=True)

class ReviewResource(Resource):
	@marshal_with(resource_fields)
	def post(self, username):
		args = review_put_args.parse_args()
		hike_id = args['hike_id']
		like = args['like']
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
		return jsonify({'success': True}), 202
