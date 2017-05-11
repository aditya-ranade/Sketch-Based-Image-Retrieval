import json

# FILE_NAME
with open('extended/freq_hist.json', 'r') as infile:
    data = json.load(infile)
    print("here")
    infile.close()

freq_hist_normalized = dict()
for image in data:
    curr_freq_hist = data[image]
    hist_sum = 0
    for elem in curr_freq_hist:
        hist_sum += elem
    norm_freq_hist = list()
    for elem in curr_freq_hist:
        norm_freq_hist.append(elem/hist_sum)
    freq_hist_normalized[image] = norm_freq_hist

# FILE_NAME
with open('extended/freq_hist_normalized.json', 'w') as outfile:
    json.dump(freq_hist_normalized, outfile)
    outfile.close()


