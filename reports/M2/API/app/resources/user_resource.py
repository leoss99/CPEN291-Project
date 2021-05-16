from flask_restful import Resource, reqparse, abort, fields, marshal_with
import random
from flask import jsonify, request
from models import Hike, User, hikes, users
import json

resource_fields = {
	'username': fields.String,
	'length_min': fields.Integer,
	'length_max': fields.Integer,
	'gain_min': fields.Integer,
	'gain_max': fields.Integer,
	'easy': fields.String,
	'moderate': fields.String,
	'hard':  fields.String
}

#user_put_args = reqparse.RequestParser()
#user_put_args.add_argument("length_min", type=int, help="Minimum distance required", required=True)
#user_put_args.add_argument("length_max", type=int, help="Maximum distance required", required=True)
#user_put_args.add_argument("gain_min", type=int, help="Minimum elevation required", required=True)
#user_put_args.add_argument("gain_max", type=int, help="Maximum elevation required", required=True)
#user_put_args.add_argument("easy", type=bool, help="Easy preference required", required=True)
#user_put_args.add_argument("moderate", type=bool, help="Moderate preference required", required=True)
#user_put_args.add_argument("hard", type=bool, help="Hard preference required", required=True)


class UserResource(Resource):
	@marshal_with(resource_fields)
	def get(self, username):
		print("Getting! Username: " + username)
		retval = [user for user in users if user.username == username]
		if len(retval) == 0:
			abort(404, message="Could not find a user with that username")
		else:
			return retval[0]

	def post(self, username):
		print("post received")
		print("Username: " + username)
		json_data = request.get_json(force=True)
		json_data = json.loads(json_data)
		retval = [user for user in users if user.username == username]
		if len(retval) != 0:
			abort(409, message="User with that username already exists")
		else:
			if (json_data['easy'] == 'True'):
				easy = True
			else:
				easy = False
			if (json_data['moderate'] == 'True'):
				moderate = True
			else:
				moderate = False
			if (json_data['hard'] == 'True'):
				hard = True
			else:
				hard = False

			newUser = User(username=username, length_min=json_data['length_min'], length_max=json_data['length_max'], gain_min=json_data['gain_min'],
				gain_max=json_data['gain_max'], easy=easy, moderate=moderate, hard=hard)
			users.append(newUser)
			return 202




