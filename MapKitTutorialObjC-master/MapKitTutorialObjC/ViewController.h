//
//  ViewController.h
//  HackathonTravelPlanner
//
//  Created by IBM on 04/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WeatherResponseParser.h"

@import MapKit;
#define kGOOGLE_API_KEY @"AIzaSyAZD2Wwnyh-dk6o1l_m3vrYu7r2DtfOQnU"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@protocol HandleMapSearch <NSObject>
- (void)dropPinZoomIn:(MKPlacemark *)placemark :(int)Tag;
@end

@interface ViewController : UIViewController <CLLocationManagerDelegate, HandleMapSearch, MKMapViewDelegate,WeatherDataParseDelegate>{
    WeatherResponseParser * sharedObject;
    NSString* latitude;
    NSString* longitude;
    int numberOfDays;
    int currenDist;
    CLLocationCoordinate2D currentCentre;
    MKPlacemark *globalPlacemark;
  }
- (IBAction)POIClick:(id)sender;
- (IBAction)submitBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *vw_UserSelection;
@property (weak, nonatomic) IBOutlet UITextField *txtToLocation;
@property (weak, nonatomic) IBOutlet UITextField *datePicketText;
@property (weak, nonatomic) IBOutlet UILabel *lbl_poi;
@property (weak, nonatomic) IBOutlet UIButton *btn_bar;
@property (weak, nonatomic) IBOutlet UIButton *btn_cafe;
@property (weak, nonatomic) IBOutlet UIButton *btn_florist;
@property (weak, nonatomic) IBOutlet UIButton *btn_atm;
@property (weak, nonatomic) IBOutlet UIButton *btn_park;

@end

