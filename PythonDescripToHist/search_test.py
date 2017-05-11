import json
import numpy as np
import math
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

image_descriptors = np.float32(np.genfromtxt('working_images/burj_arab_slu.txt', delimiter = ','))[:, :81]
k = 2000
# FILE_NAME
with open("new/freq_hist_normalized.json") as infile:
    images_freq_hist = json.load(infile)
    infile.close()

# FILE_NAME
with open("new/centers.json") as infile:
    cluster_centers = json.load(infile)
    infile.close()

for i in range(len(cluster_centers)):
    cluster_centers[i] = np.float64(cluster_centers[i])

for img in images_freq_hist:
    images_freq_hist[img] = np.float64(images_freq_hist[img])

term_freq = np.zeros(k)
for i in range(k):
    for search_img in images_freq_hist:
        if (images_freq_hist[search_img][i] != 0.0):
            term_freq[i] += 1

    if term_freq[i] == 0: term_freq[i]
inverse_tf = np.zeros(k)
for i in range(k):
    if term_freq[i] == 0: 
        print("BCBC")
        inverse_tf[i] = math.log(k)
    else: inverse_tf[i] = math.log(k/term_freq[i])


# with open("new/inverse_tf.json", "w") as outfile:
#     json.dump(inverse_tf.tolist(), outfile)
#     outfile.close()
# w = np.multiply(term_freq, inverse_tf)


def getBestCluster(descriptor, centers):
    min_dist = None
    best_cluster = None
    best_label = None
    for i, center in enumerate(centers):
        # center = np.float32(center)
        dist = np.linalg.norm(descriptor - center)
        if (min_dist == None or dist < min_dist):
            best_label = i
            min_dist = dist
    return best_label

image_hist = np.zeros(k)
for descriptor in image_descriptors:
    label = getBestCluster(descriptor, cluster_centers)
    image_hist[label] += 1

print(len(inverse_tf))
hist_sum = 0
for elem in image_hist:
    hist_sum += elem
norm_freq_hist = np.zeros(k)
for i, elem in enumerate(image_hist):
    norm_freq_hist[i] = elem/hist_sum

images_dist = dict()
for search_img in images_freq_hist:
    # images_dist[search_img] = 1 - np.dot(images_freq_hist[search_img], np.multiply(norm_freq_hist, inverse_tf))
    images_dist[search_img] = (1*np.linalg.norm(np.multiply(images_freq_hist[search_img] - norm_freq_hist, inverse_tf))
        + 0*(1 - np.dot(images_freq_hist[search_img], np.multiply(norm_freq_hist, inverse_tf))))
    #np.linalg.norm(np.multiply(
        # images_freq_hist[search_img] * np.multiply(norm_freq_hist, inverse_tf)))

search = sorted(images_dist.keys(), key = lambda x: images_dist[x])
result = list()
for elem in search:
    result.append((elem, images_dist[elem]))

total_hist = np.zeros(k)
for i in range(20):
    total_hist = total_hist + images_freq_hist[search[i]]
    if i < 6:
        img = mpimg.imread('../resize_img' + search[6-i][6:])
        plt.subplot(2, 6, 6-i)
        plt.axis('off')
        imgplot = plt.imshow(img)

total_hist = total_hist/20

images_dist2 = dict()
for search_img in images_freq_hist:
    # images_dist[search_img] = 1 - np.dot(images_freq_hist[search_img], np.multiply(norm_freq_hist, inverse_tf))
    images_dist2[search_img] = np.linalg.norm(np.multiply(images_freq_hist[search_img] - total_hist, inverse_tf))

    # images_dist2[search_img] = np.dot(np.multiply(images_freq_hist[search_img] - total_hist, inverse_tf)
    #     , np.multiply(images_freq_hist[search_img] - norm_freq_hist, inverse_tf))


search2 = sorted(images_dist2.keys(), key = lambda x: images_dist2[x])
result2 = list()
for elem in search2:
    result2.append((elem, images_dist2[elem]))

# FILE_NAME
for i in range(6):
    img = mpimg.imread('../resize_img' + search2[6-i][6:])
    plt.subplot(2, 6, 12 - i)
    plt.axis('off')
    imgplot = plt.imshow(img)


plt.show()

# print(search)

