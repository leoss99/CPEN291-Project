import torch, torchvision
from torch import nn, optim
from torchvision import datasets, models, transforms
import matplotlib.pyplot as plt
import os
import pdb
from PIL import Image
import shutil

class ImageClassifier():
	def __init__(self, in_hikes, liked_hikes, disliked_hikes):
		self.input_hikes = []
		self.in_hikes = in_hikes
		for hike in in_hikes:
			self.input_hikes.append(hike.hike_id)

		self.liked_hikes = liked_hikes
		self.disliked_hikes = disliked_hikes
		self.recommended_hikes = []
		self.model = None
		self.device = None
		self.optimizer = None
		self.scheduler = None
		self.criterion = None
		self.dataset_train = None
		self.dataset_test = None
		self.loader_train = None
		self.loader_test = None

	def label_image(self, img_name,label):
		source_dir = "291_test_dataset/unrated"
		if not(os.path.isfile(f"{source_dir}/{img_name}.jpg")):
		    # If an image is missing from a hike, ignore it
		    return
		if label == 1: # Image is liked
		    target_dir = "291_test_dataset/full_dataset/likes"
		else: # Image is disliked
		    target_dir = "291_test_dataset/full_dataset/dislikes"
		shutil.move(f"{source_dir}/{img_name}.jpg", target_dir)

	def label_hike(self, hike_name, label):
		for i in range(3):
		    image_name = hike_name + '-' + str(i)
		    self.label_image(image_name, label)

	def label_hikes(self):
		self.label_liked_hikes()
		self.label_disliked_hikes()


	def label_liked_hikes(self):
		for i in range(len(self.liked_hikes)):
			self.label_hike(self.liked_hikes[i], 1)

	def label_disliked_hikes(self):
		for i in range(len(self.disliked_hikes)):
			self.label_hike(self.disliked_hikes[i], 0)


	def create_dataset(self):
		xform = transforms.Compose([transforms.RandomHorizontalFlip(p=0.5),
                            transforms.ColorJitter(brightness=0.1,contrast=0.3,saturation=0.2),
                            transforms.GaussianBlur(kernel_size=5),
                            transforms.Resize((224,224)), transforms.ToTensor()])
		dataset_full = datasets.ImageFolder('291_test_dataset/full_dataset', transform=xform)
		n_all = len(dataset_full)
		n_train = int(0.6 * n_all)
		n_test = n_all - n_train
		rng = torch.Generator().manual_seed(3621)
		self.dataset_train, self.dataset_test = torch.utils.data.random_split(dataset_full, [n_train, n_test], rng)

		self.loader_train = torch.utils.data.DataLoader(self.dataset_train, batch_size = 4, shuffle=True)
		self.loader_test = torch.utils.data.DataLoader(self.dataset_test, batch_size = 4, shuffle=True)

	def create_model(self):
		self.model = models.resnet18(pretrained=True)
		self.model.fc = nn.Sequential(nn.Dropout(p=0.2),
	                         nn.Linear(self.model.fc.in_features, 2))
		torch.nn.init.xavier_uniform_(self.model.fc[1].weight)
		self.device = torch.device('cpu')
		self.model = self.model.to(self.device)
		self.optimizer = optim.SGD(self.model.parameters(), lr=0.001)
		self.scheduler = optim.lr_scheduler.StepLR(self.optimizer, step_size=5, gamma=0.1)
		self.criterion = nn.CrossEntropyLoss()

	def run_train(self, model, opt, sched):
	  nsamples_train = len(self.dataset_train)
	  loss_sofar, correct_sofar = 0, 0
	  model.train()
	  with torch.enable_grad():
	    for samples, labels in self.loader_train:
	      samples = samples.to(self.device)
	      labels = labels.to(self.device)
	      opt.zero_grad()
	      outs = model(samples)
	      _, preds = torch.max(outs.detach(), 1)
	      loss = self.criterion(outs, labels)
	      loss.backward()
	      opt.step()
	      loss_sofar += loss.item() * samples.size(0)
	      correct_sofar += torch.sum(preds == labels.detach())
	  sched.step()
	  return loss_sofar / nsamples_train, correct_sofar / nsamples_train

	def run_test(self, model):
	  n_test = len(self.dataset_test)
	  loss, correct = 0, 0
	  model.eval()
	  with torch.no_grad():
	    for samples, labels in self.loader_test:
	      samples = samples.to(self.device)
	      labels = labels.to(self.device)
	      outs = model(samples)
	      loss += self.criterion(outs, labels)
	      _, preds = torch.max(outs.detach(), 1)
	      correct_mask = preds == labels
	      correct += correct_mask.sum(0).item()
	  return loss / n_test, correct / n_test

	def run_all(self, n_epochs):
	  for epoch in range(n_epochs):
	    loss_train, acc_train = self.run_train(self.model, self.optimizer, self.scheduler)
	    loss_test, acc_test = self.run_test(self.model)
	    print(f"epoch {epoch}: train loss {loss_train:.4f} acc {acc_train:.4f}, test loss {loss_test:.4f} acc {acc_test:.4f}")

	def predict_image_score(self, img_name):
	    # Find the image in the folder and prepare it for the model
	    img_path = '291_test_dataset/unrated/' + img_name + '.jpg'
	    try:
	        pil_img = Image.open(img_path).convert('RGB')
	    except:
	        # If image cannot be found, return 0 for dislike
	        print("Image not found")
	        return torch.tensor([[1.,-1.]])

	    img_transform = transforms.Compose([transforms.Resize((224,224)), transforms.ToTensor()])
	    img = img_transform(pil_img) # Transform image

	    self.model.eval()
	    with torch.no_grad():
	        img = img.to(self.device).unsqueeze(0) # Add a dimension so the model can use it
	        out = self.model(img)
	    return out.detach()

	# Given a single image in the unrated folder, predict how the user will rate it
	def classify_image(self, img_name):
	    score = self.predict_image_score(img_name)
	    _, pred = torch.max(score, 1)
	    return pred.item()

	def classify_hike(self, hike_name):
	    source_dir = "291_test_dataset/unrated"
	    image_scores = []
	    for i in range(3):
	        image_name = hike_name + '-' + str(i)
	        # Check if the hike is in the unrated folder
	        if not(os.path.isfile(f"{source_dir}/{image_name}.jpg")):
	            continue
	        # Predict the score 
	        image_scores += self.predict_image_score(image_name)
	    
	    # If there are no images found, return dislike
	    if (len(image_scores) == 0):
	    	return 0

	    # Combine the predicted scores for all images, then predict class based on the mean score
	    score_tensor = torch.stack(image_scores)
	    score_tensor = torch.transpose(score_tensor, 0, 1)
	    mean_score = torch.mean(score_tensor, 1, True)
	    mean_score = torch.transpose(mean_score, 0, 1)
	    _, pred = torch.max(mean_score, 1)
	    return pred.item()

	def classify_recommended_hikes(self):
		for hike_id in self.input_hikes:
			if (self.classify_hike(hike_id) == 1):
				hike = next((hike for hike in self.in_hikes if hike.hike_id == hike_id), None)
				self.recommended_hikes.append(hike)


	def run(self):
		#Label the hikes and images
		self.label_hikes()
		#Create the dataset based on the inputs
		self.create_dataset()
		#Create the model to be used
		self.create_model()
		#Run the testing/training (won't need to run training in future examples)
		self.run_all(5)
		#Classify the recommended hikes
		self.classify_recommended_hikes()

		return self.recommended_hikes



