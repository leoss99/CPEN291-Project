from flask_restful import Resource, reqparse, abort, fields, marshal_with
import random
from flask import jsonify, make_response
from models import Hike, User, hikes, users

resource_fields = {
	'username': fields.String,
	'length_min': fields.Integer,
	'length_max': fields.Integer,
	'gain_min': fields.Integer,
	'gain_max': fields.Integer,
	'easy': fields.Boolean,
	'moderate': fields.Boolean,
	'hard':  fields.Boolean
}

user_put_args = reqparse.RequestParser()
user_put_args.add_argument("length_min", type=int, help="Minimum distance required", required=True)
user_put_args.add_argument("length_max", type=int, help="Maximum distance required", required=True)
user_put_args.add_argument("gain_min", type=int, help="Minimum elevation required", required=True)
user_put_args.add_argument("gain_max", type=int, help="Maximum elevation required", required=True)
user_put_args.add_argument("easy", type=bool, help="Easy preference required", required=True)
user_put_args.add_argument("moderate", type=bool, help="Moderate preference required", required=True)
user_put_args.add_argument("hard", type=bool, help="Hard preference required", required=True)


class UserResource(Resource):
	@marshal_with(resource_fields)
	def get(self, username):
		retval = [user for user in users if user.username == username]
		if len(retval) == 0:
			abort(404, message="Could not find a user with that username")
		else:
			return retval[0]

	def post(self, username):
		args = user_put_args.parse_args()
		retval = [user for user in users if user.username == username]
		if len(retval) != 0:
			abort(409, message="User with that username already exists")
		else:
			newUser = User(username=username, length_min=args['length_min'], length_max=args['length_max'], gain_min=args['gain_min'],
				gain_max=args['gain_max'], easy=args['easy'], moderate=args['moderate'], hard=args['hard'])
			users.append(newUser)
			return 202




