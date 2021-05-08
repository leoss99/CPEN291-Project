import requests
BASE = "http://127.0.0.1:5000/"

#Adds a user to the system
def test_user_post():
	arg = "taylor-mcouat"
	PARAMS = {'distance_min': '0', 'distance_max': '1000',
	'elevation_min': '0', 'elevation_max': '100', 'easy': 'True', 'medium': '', 'hard': ''}
	response = requests.post(BASE + "user/" + arg, PARAMS)

#Gets the user back to ensure it is added
def test_user_get():
	arg = "taylor-mcouat"
	response = requests.get(BASE + "user/" + arg)
	print(response.json())

#Tests to see if it returns a hike
def test_review_post():
	arg = "taylor-mcouat"
	PARAMS = {'hike_id': 'wapta-falls', 'like': ''}
	response = requests.post(BASE + "review/" + arg, PARAMS)

#Tests to see if review is in the system
def test_review_get():
	arg = "taylor-mcouat"
	PARAMS = {'hike_id': 'wapta-falls'}
	response = requests.get(BASE + "review/" + arg, PARAMS)
	print(response.json())

#Tests to see if hike is in the system
def test_hike_get():
	arg = "taylor-mcouat"
	response = requests.get(BASE + "hike/" + arg)
	print(response.json())

test_user_post()
test_user_get()
test_review_post()
test_review_get()
test_hike_get()