from flask_restful import Resource, reqparse, abort, fields, marshal_with
import random
from flask import jsonify, make_response
from models import Hike, User, hikes, users

resource_fields = {
	'username': fields.String,
	'distance_min': fields.Integer,
	'distance_max': fields.Integer,
	'elevation_min': fields.Integer,
	'elevation_max': fields.Integer,
	'easy': fields.Boolean,
	'medium': fields.Boolean,
	'hard':  fields.Boolean
}

user_put_args = reqparse.RequestParser()
user_put_args.add_argument("distance_min", type=int, help="Minimum distance required", required=True)
user_put_args.add_argument("distance_max", type=int, help="Maximum distance required", required=True)
user_put_args.add_argument("elevation_min", type=int, help="Minimum elevation required", required=True)
user_put_args.add_argument("elevation_max", type=int, help="Maximum elevation required", required=True)
user_put_args.add_argument("easy", type=bool, help="Easy preference required", required=True)
user_put_args.add_argument("medium", type=bool, help="Medimum preference required", required=True)
user_put_args.add_argument("hard", type=bool, help="Hard preference required", required=True)


class UserResource(Resource):
	@marshal_with(resource_fields)
	def get(self, username):
		retval = [user for user in users if user.username == username]
		if len(retval) == 0:
			abort(404, message="Could not find a user with that username")
		else:
			return retval[0]

	@marshal_with(resource_fields)
	def post(self, username):
		args = user_put_args.parse_args()
		retval = [user for user in users if user.username == username]
		if len(retval) != 0:
			abort(409, message="User with that username already exists")
		else:
			newUser = User(username=username, distance_min=args['distance_min'], distance_max=args['distance_max'], elevation_min=args['elevation_min'],
				elevation_max=args['elevation_max'], easy=args['easy'], medium=args['medium'], hard=args['hard'])
			users.append(newUser)
			return jsonify({'success': True}), 202




