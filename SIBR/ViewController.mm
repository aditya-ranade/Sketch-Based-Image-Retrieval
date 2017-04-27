//
//  ViewController.m
//  SIBR
//
//  Created by Aditya Ranade on 4/27/17.
//  Copyright © 2017 Aditya Ranade. All rights reserved.



#import "ViewController.h"
#include <stdlib.h>
#include <opencv2/opencv.hpp>
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import "opencv2/highgui/ios.h"
#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#endif



// Include iostream and std namespace so we can mix C++ code in here
#include <iostream>
using namespace std;
using namespace cv;

@interface ViewController () {
    // Setup the view
    UIImageView *imageView_;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 3.Read in the image (of the famous Lena)
    UIImage *image = [UIImage imageNamed:@"lena.png"];
    
    // 1. Setup the your imageView_ view, so it takes up the entire App screen......
    imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - image.size.width/2, self.view.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
    
    // 2. Important: add OpenCV_View as a subview
    [self.view addSubview:imageView_];
    
    if(image != nil) imageView_.image = image; // Display the image if it is there....
    else cout << "Cannot read in the file" << endl;
    
    // 4. Next convert to a cv::Mat
    Mat cvImage; UIImageToMat(image, cvImage);
    
    // 5. Now apply some OpenCV operations
    Mat gray;
    cvtColor(cvImage, gray, CV_RGB2GRAY);
    
    
    
    
    
    
    
    
    
    
    // ALL DONE :)
}
@end

