import requests
BASE = "http://127.0.0.1:5000/"

#Adds a user to the system
def test_user_post():
	arg = "taylor-mcouat"
	PARAMS = {'length_min': '0', 'length_max': '1000',
	'gain_min': '0', 'gain_max': '1000', 'easy': '', 'moderate': 'True', 'hard': ''}
	response = requests.post(BASE + "user/" + arg, PARAMS)
	print(response)

#Gets the user back to ensure it is added
def test_user_get():
	arg = "taylor-mcouat"
	response = requests.get(BASE + "user/" + arg)
	print(response.json())

#Tests to see if it returns a hike
def test_review_post():
	arg = "taylor-mcouat"
	PARAMS = {'hike_id': 'wapta-falls', 'like': 'True'}
	response = requests.post(BASE + "review/" + arg, PARAMS)
	print(response)

#Tests to see if it returns a hike
def test_review_post2():
	arg = "taylor-mcouat"
	PARAMS = {'hike_id': 'hoodoo-trail', 'like': 'True'}
	response = requests.post(BASE + "review/" + arg, PARAMS)
	print(response)

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
test_review_post2()
test_hike_get()