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
#include <typeinfo>

#include "GFHOG.h"
#include <iostream>
#include <fstream>

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
    UIImage *image = [UIImage imageNamed:@"1.png"];
    
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
    
    std::string image_path;
    std::string mask_path;
    std::string grad_path;
    std::string out_path;
    int type = 0;
    int setSize = 100;
    
    image_path = "1.png";
    IplImage *img = CreateIplImageFromUIImage(image);
    
    if (!img){
        std::cout <<"Error Loading Image" << std::endl;
    }
    
    if (std::max(img->width,img->height) > setSize){
        // Change in size
        CvSize s;
        if (img->width > setSize){
            float r = (float)setSize / img->width ;
            s.width = setSize;
            s.height = (float)(img->height) * r;
        }else{
            float r = (float)setSize / img->height ;
            s.height = setSize;
            s.width = (float)(img->width) * r;
        }
        IplImage *resize = cvCreateImage(s,8,1);
        
        cout << typeid(resize).name() << endl;
        cout << typeid(img).name() << endl;
        
        cvResize(img,resize);
        cvReleaseImage(&img);
        img = resize;
    }
    
    IplImage* mask = NULL;
    if (mask_path.length()){
        mask = cvLoadImage(image_path.c_str(),0);
        if (!mask){
            std::cout <<"Error Loading Mask" << std::endl;
        }
        cvZero(mask);
        cvCopyMakeBorder(mask,mask,cvPoint(setSize/100,setSize/100),IPL_BORDER_CONSTANT);
    }else{
        mask = cvCreateImage(cvGetSize(img),8,1);
        cvZero(mask);
        cvNot(mask,mask);
        //cvCopyMakeBorder(mask,mask,cvPoint(setSize/10,setSize/10),IPL_BORDER_CONSTANT);
    }
    
    GFHOG descriptor;
    
    cout << "adasx" << endl;
    
    descriptor.Compute(img,(GFHOGType)type,mask);
    
    printf("ad");
    
    out_path = "~/Desktop/output.txt";
    int sum1 = 0;
    GFHOG::iterator it = descriptor.begin();
    printf("\n");
    for ( ; it < descriptor.end() ; it++){
        sum1 += 1;
        float sum = 0;
        std::vector<double>::iterator it1 = it->begin();
        //cout << *it1;
        it1++;
        for (; it1 < it->end(); it1++) {
            cout << ',' << *it1;
            sum += *it1;
        }
        //printf("\n\n%f\n\n", sum);
    }
    //printf("\n%d", sum1);
    if (out_path.length()){
        //descriptor.saveToFile(out_path.c_str());
        std::ofstream str;
        str.open(out_path.c_str());
        if (str.is_open()){
            GFHOG::iterator it = descriptor.begin();
            for ( ; it < descriptor.end() ; it++){
                writeVector(*it,str);
                str << std::endl;
            }
        }else{
            printf("\n");
            std::cout << "Failed to Save Descriptor" << std::endl;
        }
    }
    
    if (grad_path.length()){
        IplImage* g = descriptor.Gradient();
        IplImage* g8bit = cvCreateImage(cvGetSize(g),8,1);
        cvConvertScale(g,g8bit,255);
        cvSaveImage(grad_path.c_str(),g8bit);
    }
    
    
}

void writeVector(std::vector<double>& v, std::ofstream &str){
    std::vector<double>::iterator it = v.begin();
    str << *it;
    it++;
    for ( ; it < v.end() ; it++){
        str  << ',' << *it;
    }
}

IplImage *CreateIplImageFromUIImage(UIImage *image) {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 1);
    cvCvtColor(iplimage, ret, CV_RGBA2GRAY);
    cvReleaseImage(&iplimage);
    
    return ret;
}
//https://sites.google.com/site/iprinceps/Home/iphone-1/converting-images-between-uiimage-and-iplimage

// ALL DONE :)
@end
