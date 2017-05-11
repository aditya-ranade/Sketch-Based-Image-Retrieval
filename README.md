# SIBR

Running the Python Code:

All areas which require a file are marked with '# FILE_NAME' comment on the previous line, so please change these according to your preferable paths.

Create frequency histograms:

Follow our descriptor generation process to create descriptors, which serve as the input. Run the script cvtest.py. You should now have files freq_hist.json, labels.json and centers.json, which is a Map with the frequency histogram for each image.

Run normalize_hist.json with the freq_hist.json file given as the input file in the marked area of the code. You should now have a file freq_hist_normalized.json which is passed to the search

Run search_test.py with the freq_hist_normalized.json file and the centers.json file locations placed in the appropirate areas. If running in a REPL, the variable search gives the normal search results and search2 is our optimization technique, which still needs to be thoroughly tested and improved. Currently matplotlib prints the first few results of the two methods in different rows.

extend_dataset.py can be used to extend the dataset of images to be searched. It needs the locations of freq_hist_normalized.json and another set of descriptors created by our generation process.

We currently use the data in new/* for our python testing.
