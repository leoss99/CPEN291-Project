from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()

class HikeModel(db.Model):
	hike_id = db.Column(db.String(250), primary_key=True)
	name = db.Column(db.String(250), nullable=False)
	location = db.Column(db.String(250), nullable=False)
	difficulty = db.Column(db.String(250), nullable=False)
	length = db.Column(db.Float, nullable=False)
	gain = db.Column(db.Integer, nullable=False)
	hiketype = db.Column(db.String(15), nullable=False)
	url = db.Column(db.String(250), nullable=False)
	#img names (for relative path)
	img_1 = db.Column(db.String(250), nullable=False)
	img_2 = db.Column(db.String(250), nullable=False)
	img_3 = db.Column(db.String(250), nullable=False)
	keywords = db.Column(db.String(1000), nullable=False)

	def __repr__(self):
		return f"Hike(name={name}, location={location}, difficulty={difficulty}, length={length}, gain={gain}, hiketype={hiketype}, url={url}, image 1 name={img_1}, image 2 name={img_2}, image 3 name={img_3}, keywords={keywords}"

class LikedHikes(db.Model):
	user_id = db.Column(db.String(250), primary_key=True)
	hike_id = db.Column(db.String(250), primary_key=True)

class DislikedHikes(db.Model):
	user_id = db.Column(db.String(250), primary_key=True)
	hike_id = db.Column(db.String(250), primary_key=True)

