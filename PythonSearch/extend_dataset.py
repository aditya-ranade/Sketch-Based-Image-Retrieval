import json 
import numpy as np
import pandas as pd

k = 2000

# FILE_NAME
with open('new/freq_hist.json') as infile:
    data = json.load(infile)
    infile.close()

# FILE_NAME
with open('new/centers.json') as infile:
    centers = np.float64(json.load(infile))
    infile.close()

# FILE_NAME
descriptors = pd.read_csv('extended/extended_descriptors.txt', delimiter = ',').values
extended_data = np.float64(descriptors[:,0:81])
images = descriptors[:, 81]
print(len(extended_data))
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


for i in range(len(extended_data)):
    curr_label = getBestCluster(extended_data[i], centers)
    curr_image = images[i]#[sampleInd_new[i]]
    if curr_image not in data:
        data[curr_image] = np.zeros(k)
    data[curr_image][curr_label] += 1
    if (i % 1000 == 0): print(i)

print(len(extended_data))
freq_hist_to_save = dict()
for key in data:
    freq_hist_to_save[key] = data[key].tolist()

# FILE_NAME
with open('extended/freq_hist.json', 'w') as outfile:
    json.dump(freq_hist_to_save, outfile)
    outfile.close()
