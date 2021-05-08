import requests
BASE = "http://127.0.0.1:5000/"
arg = "wapta-falls"
response = requests.get(BASE + "hike/" + arg)
print(response.json())