from flask import jsonify
from numpy import dot
from numpy.linalg import norm

hikes = []
users = []
MAX_GAIN = 4026
MAX_LENGTH = 76
MAX_RATING = 5
RELEVANT_WORDS = ["Dogs on leash", "Kid friendly", "Hiking", "Views", "Nature trips", "Forest", "Waterfall", "River", "Lake", "Camping"]

class User():
	def  __init__(self, username, length_min, length_max, gain_min, gain_max, easy, moderate, hard):
		self.new_user = True
		self.username = username
		self.length_min = length_min
		self.length_max = length_max
		self.gain_min = gain_min
		self.gain_max = gain_max
		self.easy = easy
		self.moderate = moderate
		self.hard = hard
		self.num_reviews = 0
		#Hikes that have been liked
		self.liked_hikes = []
		#Hikes that have been disliked
		self.disliked_hikes = []
		#Hikes that are available to be recommended (have not been seen before)
		self.attributes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

		self.available_hikes = [hike for hike in hikes if ((hike.difficulty == "easy" and self.easy == True) or (
			hike.difficulty == "moderate" and self.moderate == True) or (hike.difficulty == "hard" and self.hard == True) and 
		hike.length >= self.length_min and hike.length <= self.length_max and hike.gain >= self.gain_min and hike.gain <= self.gain_max)]


	def review_hike(self, hike, like):
		self.num_reviews = self.num_reviews + 1
		if like is False:
			self.disliked_hikes.append(hike.hike_id)
			return

		self.liked_hikes.append(hike.hike_id)

		#Update the difficulty attributes
		if (hike.difficulty == "easy"):
			self.attributes[0] = (self.attributes[0]*(self.num_reviews - 1) + 1)/(self.num_reviews)
		elif (hike.difficulty == "moderate"):
			self.attributes[1] = (self.attributes[1]*(self.num_reviews - 1) + 1)/(self.num_reviews)
		else:
			self.attributes[2] = (self.attributes[2]*(self.num_reviews - 1) + 1)/(self.num_reviews)

		#Update the route type attributes
		if (hike.hiketype == "Loop"):
			self.attributes[3] = (self.attributes[3]*(self.num_reviews - 1) + 1)/(self.num_reviews)
		elif (hike.difficulty == "Out & Back"):
			self.attributes[4] = (self.attributes[4]*(self.num_reviews - 1) + 1)/(self.num_reviews)
		else:
			self.attributes[5] = (self.attributes[5]*(self.num_reviews - 1) + 1)/(self.num_reviews)

		#Update the gain/length/rating
		self.attributes[6] = (self.attributes[6]*(self.num_reviews - 1) + hike.length/MAX_LENGTH)/(self.num_reviews)
		self.attributes[7] = (self.attributes[7]*(self.num_reviews - 1) + hike.gain/MAX_GAIN)/(self.num_reviews)
		self.attributes[8] = (self.attributes[8]*(self.num_reviews - 1) + hike.rating/MAX_RATING)/(self.num_reviews)

		#Update the keyword section
		for i in range(9,19):
			if RELEVANT_WORDS[i - 9] in hike.keywords:
				self.attributes[i] = (self.attributes[i]*(self.num_reviews - 1) + 1)/(self.num_reviews)

	def get_recommended_hike(self, numb):
		rec = self.available_hikes[0]
		if (len(self.liked_hikes) != 0 or not self.new_user):
			max_cos_sim = 0
			for hike in self.available_hikes:
				cos_sim = dot(hike.attributes, self.attributes)/(norm(hike.attributes)*norm(self.attributes))
				if (cos_sim > max_cos_sim):
					rec = hike
					max_cos_sim = cos_sim

		self.available_hikes.remove(rec)
		return rec

	def 


class Hike():
	def __init__(self, hike_id, name, rating, location, difficulty, length, gain, hiketype, url, img_1, img_2, img_3, keywords):
		self.hike_id = hike_id
		self.name = name
		self.rating = rating
		self.location = location
		self.difficulty = difficulty
		self.length = length
		self.gain = gain
		self.hiketype = hiketype
		self.url = url
		self.img_1 = img_1
		self.img_2 = img_2
		self.img_3 = img_3 
		self.keywords = keywords.split(", ")
		#Index 0-2 for difficulty, index 3-5 for route type, index 6 for length, index 7 for gain, 
		#index 8 for rating, 9-18 for keywords
		self.attributes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

		if self.difficulty == "easy":
			self.attributes[0] = 1
		elif self.difficulty == "moderate":
			self.attributes[1] = 1
		else:
			self.attributes[2] = 1

		if self.hiketype == "Loop":
			self.attributes[3] = 1
		elif self.hiketype == "Out & Back":
			self.attributes[4] = 1
		else:
			self.attributes[5] = 1

		#Normalize the lengths so they don't overpow the cosine similarity equation
		self.attributes[6] = int(self.length)/MAX_LENGTH
		self.attributes[7] = int(self.gain)/MAX_GAIN
		self.attributes[8] = int(self.rating)/MAX_RATING
		#Initialize the attributes for keywords
		for i in range(9, 19):
			if RELEVANT_WORDS[i - 9] in self.keywords: 
				self.attributes[i] = 1
		



