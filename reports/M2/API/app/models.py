from flask import jsonify
hikes = []
users = []

class User():
	def  __init__(self, username, distance_min, distance_max, elevation_min, elevation_max, easy, medium, hard):
		self.username = username
		self.distance_min = distance_min
		self.distance_max = distance_max
		self.elevation_min = elevation_min
		self.elevation_max = elevation_max
		self.easy = easy
		self.medium = medium
		self.hard = hard
		self.num_reviews = 0
		self.liked_hikes = []
		self.disliked_hikes = []

	def review_hike(self, hike, like):
		if like is True:
			self.liked_hikes.append(hike)
		else:
			self.disliked_hikes.append(hike)

	def get_recommended_hike(self):
		return hikes[1]

class Hike():
	def __init__(self, hike_id, name, location, difficulty, length, gain, hiketype, url, img_1, img_2, img_3, keywords):
		self.hike_id = hike_id
		self.name = name
		self.location = location
		self.difficulty = difficulty
		self.length = length
		self.gain = gain
		self.hiketype = hiketype
		self.url = url
		self.img_1 = img_1
		self.img_2 = img_2
		self.img_3 = img_3 
		self.keywords = keywords

	def get_json(self):
		dic = {'hike_id': self.hike_id, 'name': self.name, 'location': self.location, 'difficulty': self.difficulty, 'length': self.length,
		'gain': self.gain, 'hiketype': self.hiketype, 'url': self.url, 'img_1': self.img_1, 'img_2': self.img_2, 'img_3': self.img_3}
		return jsonify(dic)