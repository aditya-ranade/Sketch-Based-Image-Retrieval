//
//  ViewController.m
//  SIBR
//
//  Created by Aditya Ranade on 4/27/17.
//  Copyright © 2017 Aditya Ranade. All rights reserved.



#import "ViewController.h"
//#import "ACEDrawingView.h"
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
#include <sstream>
#include <dirent.h>
#include "rapidjson/document.h"
#include "rapidjson/filereadstream.h"
#import "CollectionViewController.h"





#endif



// Include iostream and std namespace so we can mix C++ code in here
#include <iostream>
using namespace std;
using namespace cv;
using namespace rapidjson;



typedef struct {
    GFHOG descriptor;
    string buf;
    
}return_value;
std::vector<std::pair<double, string>> mapVector;


@interface ViewController (){
    // Setup the view
    //UIImageView *imageView_;
    IBOutlet ACEDrawingView *drawView;
    
    
}
- (IBAction)clearImage:(id)sender;

- (IBAction)processImage:(id)sender;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.view addSubview:drawView];
    [drawView clear];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view addSubview:drawView];
    /*
    string buf = "";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"bruv.txt"];
    
    const char *fname = [filePath UTF8String];
    
    
    string path = "/Users/aranade/Downloads/SIBR-1acc1848f97f9435ae4946b546f01140545d0e49/SIBR/images2/";
    
    */
    
    //    DIR *dir;
    //    struct dirent *ent;
    //    if ((dir = opendir (path.c_str())) != NULL) {
    //        /* print all the files and directories within directory */
    //
    //        while ((ent = readdir (dir)) != NULL) {
    //            string new_path = path + ent->d_name;
    //            new_path += "/";
    //            DIR *sub_dir;
    //            struct dirent *sub_ent;
    //            if ((sub_dir = opendir (new_path.c_str())) != NULL) {
    //                while ((sub_ent = readdir (sub_dir)) != NULL) {
    //                    string name = new_path + sub_ent->d_name;
    //                    string check = sub_ent->d_name;
    //                    if (check.size() >= 5) {
    //                        string file_type = check.substr(check.size() - 4, check.size());
    //                        if (file_type == ".png") {
    //
    //                            string image_folder = ent->d_name;
    //
    //                            if (image_folder != "..") {
    //
    //                                string img_path = "images2/" + image_folder + "/" + check;
    //
    //                                NSString *image_path = [NSString stringWithUTF8String:img_path.c_str()];
    
    //UIImage *image = [UIImage imageNamed:@"heart.jpg"];
    
    
    //imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - image.size.width/2, self.view.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
    
    // 2. Important: add OpenCV_View as a subview
    //[self.view addSubview:imageView_];
    
    //if(image != nil) imageView_.image = image; // Display the image if it is there....
    //else cout << "Cannot read in the file" << endl;
    
    // 4. Next convert to a cv::Mat
    //Mat cvImage; UIImageToMat(image, cvImage);
    
    // 5. Now apply some OpenCV operations
    //Mat gray;
    //cvtColor(cvImage, gray, CV_RGB2GRAY);
    
    /*
    
    IplImage *img = CreateIplImageFromUIImage(image);
    
    
    int type = 0;
    int setSize = 100;
    
    std::string image_path;
    std::string mask_path;
    std::string grad_path;
    std::string out_path;
    
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
    
    GFHOG descriptor;*/
    
    //cout << "adasx" << endl;
    /*
    descriptor.Compute(img,(GFHOGType)type,mask);
    std::stringstream ss;
    
    
    
    GFHOG::iterator it1 = descriptor.begin();
    for ( ; it1 < descriptor.end() ; it1++){
        //arma::vec a(*it1);
        //a.save(fname, arma::raw_ascii);
        writeVector(*it1,&ss);
        ss << "," << "bicycle.png" << std::endl;
    }
    
    
    
    string result = ss.str();
    
    buf += result;*/
    //                            }
    //
    //                        }
    //                    }
    //                }
    //            }
    //        }
    /*
    
    NSString* data = [NSString stringWithUTF8String:buf.c_str()];
    
    NSError *error;
    BOOL status = [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    //closedir (dir);
    //    } else {
    //        /* could not open directory */
    //        perror ("file not found");
    //
    
    /*
    Document freq_hist = read_files("/Users/akshat/Downloads/freq_hist_normalized.json");
    Document centers = read_files("/Users/akshat/Downloads/centers-3.json");
    
    Value &new_center = centers;
    Value &new_freq_hist = freq_hist;
    
    
    
    
    
    GFHOG search;
    
    
    std::map<std::string, double> rank;
    rank = descriptor.compute_search(new_freq_hist, new_center, 500);
    
    cout << rank.size() << endl;
    
    

    
    std::vector<std::pair<double, string>> mapVector;
    std::map<string, double> map1;
    // Insert entries
    for (auto iterator = rank.begin(); iterator != rank.end(); ++iterator) {
        string temp = iterator->first;
        
        std::map<string, double> map1;
        
        mapVector.push_back(make_pair(iterator->second, iterator->first));
    }
    
    sort(mapVector.begin(), mapVector.end());
    
    for (int i=0; i<mapVector.size(); i++) cout << mapVector[i].second << endl;

}*/

    //cout << rank[0] << endl;
    
//    for (map <string, double>::iterator it = rank.begin(); it != rank.end(); it++) {
//        cout << it->first << "," << it->second << endl;


    


    
    
    // Do any additional setup after loading the view, typically from a nib.
    // 3.Read in the image (of the famous Lena)
//    UIImage *image = [UIImage imageNamed:@"lena.png"];
//
//    // 1. Setup the your imageView_ view, so it takes up the entire App screen......
//    imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - image.size.width/2, self.view.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
//
//    // 2. Important: add OpenCV_View as a subview
//    [self.view addSubview:imageView_];
//    
//    if(image != nil) imageView_.image = image; // Display the image if it is there....
//    else cout << "Cannot read in the file" << endl;
//    
//    // 4. Next convert to a cv::Mat
//    Mat cvImage; UIImageToMat(image, cvImage);
//    
//    // 5. Now apply some OpenCV operations
//    Mat gray;
//    cvtColor(cvImage, gray, CV_RGB2GRAY);
//    
//    std::string image_path;
//    std::string mask_path;
//    std::string grad_path;
//    std::string out_path;
//    int type = 0;
//    int setSize = 100;
//    
//    
//    IplImage *img = CreateIplImageFromUIImage(image);
//    
//    if (!img){
//        std::cout <<"Error Loading Image" << std::endl;
//    }
//    
//    if (std::max(img->width,img->height) > setSize){
//        // Change in size
//        CvSize s;
//        if (img->width > setSize){
//            float r = (float)setSize / img->width ;
//            s.width = setSize;
//            s.height = (float)(img->height) * r;
//        }else{
//            float r = (float)setSize / img->height ;
//            s.height = setSize;
//            s.width = (float)(img->width) * r;
//        }
//        IplImage *resize = cvCreateImage(s,8,1);
//        
//        cout << typeid(resize).name() << endl;
//        cout << typeid(img).name() << endl;
//        
//         size(img,resize);
//        cvReleaseImage(&img);
//        img = resize;
//    }
//    
//    IplImage* mask = NULL;
//    if (mask_path.length()){
//        mask = cvLoadImage(image_path.c_str(),0);
//        if (!mask){
//            std::cout <<"Error Loading Mask" << std::endl;
//        }
//        cvZero(mask);
//        cvCopyMakeBorder(mask,mask,cvPoint(setSize/100,setSize/100),IPL_BORDER_CONSTANT);
//    }else{
//        mask = cvCreateImage(cvGetSize(img),8,1);
//        cvZero(mask);
//        cvNot(mask,mask);
//        //cvCopyMakeBorder(mask,mask,cvPoint(setSize/10,setSize/10),IPL_BORDER_CONSTANT);
//    }
//    
//    GFHOG descriptor;
//    
//    cout << "adasx" << endl;
//    
//    descriptor.Compute(img,(GFHOGType)type,mask);
//    
//    printf("ad");
//    
//    out_path = "descrip.txt";
//    int sum1 = 0;
//    GFHOG::iterator it = descriptor.begin();
//    printf("\n");
//    for ( ; it < descriptor.end() ; it++){
//        sum1 += 1;
//        float sum = 0;
//        std::vector<double>::iterator it1 = it->begin();
//        //cout << *it1;
//        it1++;
//        for (; it1 < it->end(); it1++) {
//           // cout << ',' << *it1;
//            sum += *it1;
//        }
//        //printf("\n\n%f\n\n", sum);
//    }
//    
//    std::stringstream ss;
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"file.txt"];
//    
//    const char *fname = [filePath UTF8String];
//    
//    
//
//    
//    int row_no = 0;
//    
//    GFHOG::iterator it1 = descriptor.begin();
//    for ( ; it1 < descriptor.end() ; it1++){
//                //arma::vec a(*it1);
//        //a.save(fname, arma::raw_ascii);
//        writeVector(*it1,&ss);
//        ss << std::endl;
//    }
//    string result = ss.str();
//    
//    NSString* data = [NSString stringWithUTF8String:result.c_str()];
//    
//    NSError *error;
//    BOOL status = [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//
//    
//    
//    
    
    //cout << result << endl;
    
    
    
    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains
//    (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *fileName = [NSString stringWithFormat:@"%@/FFT_Comparison.txt",
//                          documentsDirectory];
//    const char *fname = [fileName UTF8String];
//
//    for ( ; it < descriptor.end() ; it++){
//        descriptor.writeVector(*it, fname);
//    }
//    

    
    //printf("\n%d", sum1);
//    if (out_path.length()){
//        //descriptor.saveToFile(out_path.c_str());
//        std::ofstream str;
//        str.open(out_path.c_str());
//        if (str.is_open()){
//            GFHOG::iterator it = descriptor.begin();
//            for ( ; it < descriptor.end() ; it++){
//                writeVector(*it,str);
//                str << std::endl;
//            }
//        }else{
//            printf("\n");
//            std::cout << "Failed to Save Descriptor" << std::endl;
//        }
//    }
    
//    if (grad_path.length()){
//        IplImage* g = descriptor.Gradient();
//        IplImage* g8bit = cvCreateImage(cvGetSize(g),8,1);
//        cvConvertScale(g,g8bit,255);
//        cvSaveImage(grad_path.c_str(),g8bit);
//    }
//
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"moveToCollection"]) {
        
        // Get destination view
        CollectionViewController *vc = [segue destinationViewController];
        cout<<"sd"<<endl;
       // cout<<mapVector[0].second.c_str()<<endl;
        // Get button tag number (or do whatever you need to do here, based on your object
        NSString *a=[NSString stringWithUTF8String:mapVector[0].second.c_str()];
        NSString *b=[NSString stringWithUTF8String:mapVector[1].second.c_str()];
        NSString *c=[NSString stringWithUTF8String:mapVector[2].second.c_str()];
        NSString *d=[NSString stringWithUTF8String:mapVector[3].second.c_str()];
        NSString *m=[NSString stringWithUTF8String:mapVector[4].second.c_str()];
        NSString *e=[NSString stringWithUTF8String:mapVector[5].second.c_str()];
        NSString *f=[NSString stringWithUTF8String:mapVector[6].second.c_str()];
        NSString *g=[NSString stringWithUTF8String:mapVector[7].second.c_str()];
        NSString *h=[NSString stringWithUTF8String:mapVector[8].second.c_str()];
        NSString *i=[NSString stringWithUTF8String:mapVector[9].second.c_str()];
        NSString *j=[NSString stringWithUTF8String:mapVector[10].second.c_str()];
        NSString *k=[NSString stringWithUTF8String:mapVector[11].second.c_str()];
        NSString *l=[NSString stringWithUTF8String:mapVector[12].second.c_str()];
        NSString *n=[NSString stringWithUTF8String:mapVector[13].second.c_str()];
        NSString *o=[NSString stringWithUTF8String:mapVector[14].second.c_str()];
        
        NSArray *pho = [NSArray arrayWithObjects: a, b, c, d, m,e,f,g,h,i,j,k,l,n,o, nil];
        
        // Pass the information to your destination view
        vc.process_photos=pho;
    }
}

return_value *create_descriptors(IplImage *img, string image_name) {
    
    int type = 0;
    int setSize = 100;
    
    std::string image_path;
    std::string mask_path;
    std::string grad_path;
    std::string out_path;
    
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
    
    //cout << "adasx" << endl;
    
    descriptor.Compute(img,(GFHOGType)type,mask);
    std::stringstream ss;
    
    
 
    GFHOG::iterator it1 = descriptor.begin();
    for ( ; it1 < descriptor.end() ; it1++){
        //arma::vec a(*it1);
        //a.save(fname, arma::raw_ascii);
        writeVector(*it1,&ss);
        ss << "," << "bicycle.png" << std::endl;
    }
    
    
    
    string result = ss.str();
    
    
    return_value *A = (return_value *)malloc(sizeof(return_value));
    A->descriptor = descriptor;
    A->buf = result;
    return A;
    
    
}


void writeVector(std::vector<double>& v, stringstream *ss){
    std::vector<double>::iterator it = v.begin();
    *ss << *it;
    it++;
    for ( ; it < v.end() ; it++){
        *ss  << ',' << *it;
        
        
    }
}



Document read_files(string file_name) {
    FILE* pFile = fopen(file_name.c_str(), "r");
    if (!pFile) cout << "fuck" << endl;
    char buffer[1700000];
    FileReadStream is(pFile, buffer, sizeof(buffer));
    Document document;
    document.ParseStream<0, UTF8<>, FileReadStream>(is);
    return document;
    
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
    //cvReleaseImage(&iplimage);
    
    return ret;
}
//https://sites.google.com/site/iprinceps/Home/iphone-1/converting-images-between-uiimage-and-iplimage


// ALL DONE :)


- (IBAction)clearImage:(id)sender {
    [drawView clear];
}

- (IBAction)processImage:(id)sender {
    UIGraphicsBeginImageContext(drawView.bounds.size);
    
    
    [drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *view_image = UIGraphicsGetImageFromCurrentImageContext();
    //NSArray *paths_2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *filePath2 = [[paths_2 objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
    
    // Save image.
    //[UIImage imageWithData:UIImageJPEGRepresentation(image, 0)];
    UIImage *image=[UIImage imageWithData:UIImageJPEGRepresentation(view_image, 0)]; //writeToFile:filePath2 atomically:YES];

    //UIImage *image=[UIImage imageNamed:@"/Users/akshat/Library/Developer/CoreSimulator/Devices/72699772-0359-44AF-A97D-2E3D323E6909/data/Containers/Data/Application/BDC0AEBF-1264-4E11-AAAB-37D470B9657D/Documents/Image.png"];
    
    
    //UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    string buf = "";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"bruv.txt"];
    
    const char *fname = [filePath UTF8String];
    
    
    //string path = "/Users/aranade/Downloads/SIBR-1acc1848f97f9435ae4946b546f01140545d0e49/SIBR/images2/";
    
    //UIImage *image = [UIImage imageNamed:@"heart.jpg"];
    
    
    //imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - image.size.width/2, self.view.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
    
    // 2. Important: add OpenCV_View as a subview
    //[self.view addSubview:imageView_];
    
    //if(image != nil) imageView_.image = image; // Display the image if it is there....
    //else cout << "Cannot read in the file" << endl;
    
    // 4. Next convert to a cv::Mat
    Mat cvImage; UIImageToMat(image, cvImage);
    //cout<<cvImage<<endl;
    
    // 5. Now apply some OpenCV operations
    Mat gray;
    cvtColor(cvImage, gray, CV_RGB2GRAY);
    
    
    
    IplImage *img = CreateIplImageFromUIImage(image);
    //cout<<img<<endl;
    
    
    int type = 0;
    int setSize = 100;
    
    std::string image_path;
    std::string mask_path;
    std::string grad_path;
    std::string out_path;
    
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
    
    //cout << "adasx" << endl;
    
    descriptor.Compute(img,(GFHOGType)type,mask);
    std::stringstream ss;
    
    
    
    GFHOG::iterator it1 = descriptor.begin();
    for ( ; it1 < descriptor.end() ; it1++){
        //arma::vec a(*it1);
        //a.save(fname, arma::raw_ascii);
        writeVector(*it1,&ss);
        ss << "," << "bicycle.png" << std::endl;
    }
    
    
    
    string result = ss.str();
    
    buf += result;
    //                            }
    //
    //                        }
    //                    }
    //                }
    //            }
    //        }
    
    NSString* data = [NSString stringWithUTF8String:buf.c_str()];
    
    NSError *error;
    BOOL status = [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    //closedir (dir);
    //    } else {
    //        /* could not open directory */
    //        perror ("file not found");
    //
    Document freq_hist;
    Document centers;
    Document inv_freq;
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"freq_hist_normalized" ofType:@"json"];
    if (filePath2) {
        NSString *myText = [NSString stringWithContentsOfFile:filePath2];
        if (myText) {
            std::cout<<"FUCKasdadssad\n\n\n\n\n"<<std::endl;
            std::string a=std::string([myText UTF8String]);
            freq_hist.Parse(a.c_str());
        }
    }
    NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"centers" ofType:@"json"];
    if (filePath3) {
        NSString *myText = [NSString stringWithContentsOfFile:filePath3];
        if (myText) {
            std::cout<<"FUCKasdadssad\n\n\n\n\n"<<std::endl;
            std::string b=std::string([myText UTF8String]);
            centers.Parse(b.c_str());
            
        }
    }
    NSString *filePath4 = [[NSBundle mainBundle] pathForResource:@"inverse_tf" ofType:@"json"];
    if (filePath4) {
        std::cout<<"BROOOOasdadssad\n\n\n\n\n"<<std::endl;
        NSString *myText = [NSString stringWithContentsOfFile:filePath4];
        if (myText) {
            
            std::string c=std::string([myText UTF8String]);
            inv_freq.Parse(c.c_str());
            
            
        }
    }

    
  //  Document centers = read_files("/Users/akshat/Downloads/centers.json");
    // = read_files("Users/akshat/Downloads/inverse_tf.json");
    //Document lol=read_files("inverse_tf.json");
    Value &new_center = centers;
    Value &new_freq_hist = freq_hist;
    Value &inv = inv_freq;
    
    
    
    
    
    GFHOG search;
    
    
    //std::map<std::string, double> rank;
    
    //std::vector<std::pair<double, string>> mapVector;
    
    mapVector = descriptor.compute_search(new_freq_hist, new_center,inv, 2000);
    
    //cout << rank.size() << endl;
    
    
    /*
    
    std::vector<std::pair<double, string>> mapVector;
    std::map<string, double> map1;
     Insert entries
    for (auto iterator = rank.begin(); iterator != rank.end(); ++iterator) {
        string temp = iterator->first;
        
        std::map<string, double> map1;
        
        mapVector.push_back(make_pair(iterator->second, iterator->first));
    }
     */
    
    sort(mapVector.begin(), mapVector.end());
    
    for (int i=0; i<mapVector.size(); i++) cout << mapVector[i].second << endl;
    [self performSegueWithIdentifier:@"moveToCollection" sender:sender];
    
    
}


@end
