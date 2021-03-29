from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
import time
import csv

PATH = "C:\Program Files (x86)\chromedriver.exe"
EMAIL = "" #Put your AllTrails.com email here
PASSWORD = "" # Put your AllTrails.com password here
EMAIL_FIELD = "userEmail"
PASSWORD_FIELD = "userPassword"
LOGIN_URL = "https://www.alltrails.com/login?ref=header"
MAIN_URL = "https://www.alltrails.com/canada/british-columbia"
DIV_NAME = "styles-module__containerDescriptive___3aZqQ styles-module__trailCard___2oHiP" 
BIG_DIV_NAME ="styles-module__container___3h0Z6"
FILENAME = "stats.csv"

class WebScraper(object):
	def __init__(self):
		self.driver = webdriver.Chrome(PATH)

	def login(self):
		self.driver.get(LOGIN_URL)
		user_email = self.driver.find_element_by_name(EMAIL_FIELD)
		user_email.send_keys(EMAIL)
		user_password = self.driver.find_element_by_name(PASSWORD_FIELD)
		user_password.send_keys(PASSWORD)
		user_password.send_keys(Keys.RETURN)

	def run_all(self):
		self.login()
		time.sleep(5)
		self.driver.get(MAIN_URL)
		time.sleep(10)
		self.show_more_trails(75)
		time.sleep(10)
		hrefs = self.parse_trail_page()
		row = 2000
		for href in hrefs:
			if (row < 2624):
				row = row + 1
			else:
				name, location, difficulty, rating, length, gain, route, keywords = self.visit_page(href)
				self.write_csv(row, name, location, difficulty, rating, length, gain, route, keywords, href)
				row = row + 1

	def show_more_trails(self, numb):
		i = 0
		while i < numb:
			element = WebDriverWait(self.driver, 10).until(
				EC.presence_of_element_located((By.CSS_SELECTOR,"[title^= 'Show more trails']" )))
			element.click()
			i = i + 1

	def parse_trail_page(self):
		result = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div[3]/div[2]/div[1]/div[2]')
		trails = result.find_elements_by_xpath("./*")
		names = []
		hrefs = []

		for trail in trails:
			element = trail.find_element_by_xpath("./a")
			name = element.get_attribute("text")
			href = element.get_attribute("href")
			hrefs.append(href)
			names.append(name)

		for href in hrefs:
			print(href)

		return hrefs

	def visit_page(self, url):
		self.driver.get(url)
		time.sleep(5)
		name = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div/div[1]/div/div/div/div[1]/div/h1').get_attribute('innerHTML')
		print(name)
		try:
			location = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div/div[1]/div/div/div/div[1]/div/a').get_attribute('text')
			print(location)
		except:
			location = name
			print(name)
		difficulty = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div/div[1]/div/div/div/div[1]/div/div/span[1]').get_attribute('innerHTML')
		print(difficulty)
		try:
			rating = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div/div[2]/div[1]/article/section[4]/div/div[2]/div[1]/div[1]/div/div[1]/div[2]/div[1]').get_attribute('innerHTML')
		except:
			rating = "N/A"
		print(rating)
		length = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div/div[2]/div[1]/article/section[2]/div/span[1]/span[2]').get_attribute('innerHTML')
		print(length)
		gain = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div/div[2]/div[1]/article/section[2]/div/span[2]/span[2]').get_attribute('innerHTML')
		print(gain)
		route = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div/div[2]/div[1]/article/section[2]/div/span[3]/span[2]').get_attribute('innerHTML')
		print(route)

		keywords = ""
		main_keys = self.driver.find_element_by_xpath('/html/body/div[3]/div[4]/div/div/div[2]/div[1]/article/section[3]')
		ind_keys = main_keys.find_elements_by_xpath('./span')
		for key in ind_keys:
			soup = BeautifulSoup(key.get_attribute('innerHTML'), features="html.parser")
			keywords = keywords + ", " + soup.get_text()
		return name, location, difficulty, rating, length, gain, route, keywords

	def write_csv(self, row, name, location, difficulty, rating, length, gain, route, keywords, href):
		with open(FILENAME, 'a') as stats:
			writer = csv.writer(stats, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
			writer.writerow([row, name, location, difficulty, rating, length, gain, route, keywords, href])
		stats.close()


wb = WebScraper()
wb.run_all()
