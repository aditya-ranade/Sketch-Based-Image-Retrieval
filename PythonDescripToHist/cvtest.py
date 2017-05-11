import cv2
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import matplotlib
import json
import time
from sklearn.cluster import MiniBatchKMeans

print(time.time())
k = 2000
# FILE_NAME
data_with_image = pd.read_csv("new/dataset.txt", delimiter = ',').values
# data_with_image = np.genfromtxt('descriptors.txt', delimiter = ',', dtype = object)
full_data = np.float64(data_with_image[:,0:81])
images = data_with_image[:, 81]
print(time.time())
samples = 500000
sampleInd = np.random.choice(full_data.shape[0], samples, replace=False)
data = full_data[sampleInd]
print(time.time())
data = full_data
# print(time.time())
# criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 20, 0.00001)
# criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 20, 0.00001)
# retval, label, center = cv2.kmeans(data, k, None, criteria, 10, cv2.KMEANS_RANDOM_CENTERS)

kmeans = MiniBatchKMeans(n_clusters = k, random_state = 0, init_size = 100000).fit(data)
print(time.time())

def getBestCluster(descriptor, centers):
    min_dist = None
    best_cluster = None
    best_label = None
    for i, center in enumerate(centers):
        dist = np.linalg.norm(descriptor - center)
        if (min_dist == None or dist < min_dist):
            best_label = i
            min_dist = dist
    return best_label

print(type(kmeans.cluster_centers_))
# samples_new = 2000000
# sampleInd_new = np.random.choice(full_data.shape[0], samples_new, replace=False)
sampled = full_data #[sampleInd_new]
freq_hist = dict()
for i in range(len(sampled)):
    curr_label = kmeans.labels_[i]#getBestCluster(sampled[i], kmeans.cluster_centers_)
    curr_image = images[i]#[sampleInd_new[i]]
    if curr_image not in freq_hist:
        freq_hist[curr_image] = np.zeros(k)
    freq_hist[curr_image][curr_label] += 1
    if (i % 1000 == 0): print(i)
print(time.time())

print(len(full_data))
freq_hist_to_save = dict()
for key in freq_hist:
    freq_hist_to_save[key] = freq_hist[key].tolist()

# FILE_NAME
with open('new/freq_hist.json', 'w') as outfile:
    json.dump(freq_hist_to_save, outfile)
    outfile.close()

# FILE_NAME
with open('new/labels.json', 'w') as outfile:
    json.dump(kmeans.labels_.tolist(), outfile)
    outfile.close()

# FILE_NAME
with open('new/centers.json', 'w') as outfile:
    json.dump(kmeans.cluster_centers_.tolist(), outfile)
    outfile.close()




# # plt.imshow(img, cmap='gray', interpolation='bicubic')
# # plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
# # plt.show()

# # A = data[label.ravel()==0]
# # B = data[label.ravel()==1]
# # C = data[label.ravel()==2]
# # Plot the data
# # N = len(data)
# # # cmap = plt.cm.get_cmap("hsv", N+1)
# # colors = ['r', 'g', 'b']
# # for i in range(k):
# #     A = data[label.ravel() == i]
# #     plt.scatter(A[:,0], A[:,1], c = matplotlib.cm.spectral(i/k), s = 0.1)

# # plt.scatter(A[:,0],A[:,1])
# # plt.scatter(B[:,0],B[:,1],c = 'r')
# # plt.scatter(C[:,0],C[:,1],c = 'g')
# # plt.scatter(center[:,0],center[:,1],s = 5,c = 'b', marker = 's')
# # plt.xlabel('Height'),plt.ylabel('Weight')
# # plt.show()
