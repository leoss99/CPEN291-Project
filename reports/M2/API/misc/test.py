import requests
import json
from flask import Flask, jsonify, request

BASE = "http://127.0.0.1:5000/"

#Adds a user to the system
def test_user_post():
	arg = "taylor-mcouat"
	PARAMS = {'length_min': '0', 'length_max': '1000',
	'gain_min': '0', 'gain_max': '1000', 'easy': 'False', 'moderate': 'True', 'hard': 'False'}
	print(json.dumps(PARAMS))
	response = requests.post(BASE + "user/" + arg, json=json.dumps(PARAMS))
	print(response.status_code)


#Gets the user back to ensure it is added
def test_user_get():
	arg = "taylor-mcouat"
	response = requests.get(BASE + "user/" + arg)
	print(response.json())


#Tests to see if it returns a hike
def test_review_post(PARAMS):
	arg = "taylor-mcouat"
	response = requests.post(BASE + "review/" + arg, json=json.dumps(PARAMS))
	print(response)


#Tests to see if it returns a hike
def test_review_post2():
	arg = "taylor-mcouat"
	PARAMS = {'hike_id': 'hoodoo-trail', 'like': 'True'}
	response = requests.post(BASE + "review/" + arg, json=json.dumps(PARAMS))
	print(response)


#Tests to see if review is in the system
def test_review_get():
	arg = "taylor-mcouat"
	PARAMS = {'hike_id': 'wapta-falls'}
	response = requests.get(BASE + "review/" + arg, json=json.dumps(PARAMS))
	print(response)


#Tests to see if hike is in the system
def test_hike_get():
	arg = "taylor-mcouat"
	response = requests.get(BASE + "hike/" + arg)
	print(response.json())


test_user_post()

test_user_get()
test_hike_get()
#test_review_post(PARAMS = {'hike_id': 'wapta-falls', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'stanley-park-seawall-trail', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'teapot-hill', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'tonquin-trail', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'mount-wells-summit-trail', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'mount-boucherie-from-east-boundary-road', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'tynehead-regional-park', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'heart-lake-loop', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'rooster-tree-lake-loop', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'mount-finlayson-trail', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'lesser-garibaldi-lake', 'like': 'False'})
#test_hike_get()
#test_review_post(PARAMS = {'hike_id': 'hoover-lake-loop-via-lookout', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'goldstream-falls-from-goldstream-campground', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'lightning-lakes-chain-trail-to-thunder-lake', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'broom-hill-via-ogre-loop', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'gowlland-tod-trail', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'community-forest-canyon-loop-trails', 'like': 'True'})
#test_review_post(PARAMS = {'hike_id': 'endurance-ridge-trail', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'lakit-lookout', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'bellamy-to-mckenzie-creek-trail-loop', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'hollyburn-peak-and-first-lake', 'like': 'False'})
#test_review_post(PARAMS = {'hike_id': 'skaha-lake-via-kvr-ponderosa-and-kettle-valley-rail-trail', 'like': 'False'})
#test_hike_get()