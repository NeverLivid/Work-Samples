#                                   ------ Problem 1 --------
# Use zipcode api to find all the zipcodes of San Francisco. Use OpenWeatherMap to find the current weather conditions
# (description, temp, feels_like, pressure and humidity) of those zipcodes and store them in a pandas DataFrame. 
import pandas as pd
import requests

# setting parameters for requesting sf zipcodes
key = 'P0YFiMZOOqpX43RpGIQe4HzCXzsiti1UW1U8D5ukilW8Dy81oThYuhaIxRABU8y3'
url = 'https://www.zipcodeapi.com/rest/<api_key>/city-zips.<format>/<city>/<state>'
file_format = 'json'
city = 'san francisco'
state = 'ca'
url = 'https://www.zipcodeapi.com/rest/'+key+'/city-zips.'+file_format+'/'+city+'/'+state
param = {'api_key': key, 'format': file_format, 'city': city, 'state': state}

# pulling the zipcodes
r = requests.get(url)
print(r.url)
zipcodes = r.json()

# pulling list of zipcodes from the dictionary
zipcodes = zipcodes['zip_codes']

# creating a dictionary key of each of the zipcodes from the list of zipcodes
zip_dict = {}
for zip in zipcodes:
    zip_dict[zip] = int(zip)

# setting request parameters
API_KEY='92777ecc50504ac75c8f8a7d179b2584'
URL='https://api.openweathermap.org/data/2.5/weather'
param={'appid': API_KEY, 'zip': 94104, 'units':'imperial'}
# requesting
r = requests.get(URL, params = param)
weather_test = r.json()

# testing the json output
weather_test['weather'][0]['description']

# looping through each zipcode in the dictionary
for zip in zip_dict:
    try:
        print(zip)      # testing the zipcode so we know it is an actual zipcode
        param={'appid': API_KEY, 'zip': int(zip), 'units':'imperial'} # setting the correct zip for params
        r = requests.get(URL, params=param)  # requesting from the api
        weather = r.json()  # converting to json
        zip_dict[zip] = { #taking the information we want
        'description': weather['weather'][0]['description'],
        'feels_like': weather['main']['feels_like'],
        'pressure': weather['main']['pressure'],
        'humidity': weather['main']['humidity']
        }
    except KeyError:
        continue

# converting to dataframe
sf_weather = pd.DataFrame(zip_dict)
sf_weather = sf_weather.T # flipping rows and columns to cleanliness
sf_weather



#               --------- Problem #2! ----------
# Pick an Origin (e.g. Walnut Creek) and a Destination (e.g. San Francisco).
# Write a Python program to find the travel time(based on CURRENT traffic) of the origin and destination.
# Record the travel time every 5 minutes for 1 hour. Store the time of recordings and the travel time with traffic(in seconds) in a pandas DataFrame.
import pandas as pd
import requests
from time import time, localtime, strftime, sleep

DistMat_Key = 'Get Your Own Key'
URL = "https://maps.googleapis.com/maps/api/distancematrix/json"

params = {
    'key': 'AIzaSyAftIiO2VyH8v8bG16wnOWToYilMdOTlKI',
    'origins': 'San Francisco, CA',
    'destinations': 'San Jose, CA',
    'departure_time': 'now'
}

r = requests.get(URL, params=params)
distance = r.json()

local_tup = localtime(time())
time_format = "%Y-%m-%d %H:%M:%S"
test_dict = {
        'timestamp': strftime(time_format,local_tup),
        'travel_time': distance['rows'][0]['elements'][0]['duration_in_traffic']['value']
    }

# starting the time machine
data = []
time_format = "%Y-%m-%d %H:%M:%S"
while len(data) < 20:
    sleep(300 - time() % 300)

    r = requests.get(URL, params=params)
    distance = r.json()

    local_tup = localtime(time())

    new_dict = {
        'timestamp': strftime(time_format,local_tup),
        'travel_time': distance['rows'][0]['elements'][0]['duration_in_traffic']['value']
    }
    data.append(new_dict)
    print('Iteration Complete At' + str(time()))
    continue

data = pd.DataFrame(data)
data
