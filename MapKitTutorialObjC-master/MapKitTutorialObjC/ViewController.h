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


@protocol HandleMapSearch <NSObject>
- (void)dropPinZoomIn:(MKPlacemark *)placemark :(int)Tag;
@end

@interface ViewController : UIViewController <CLLocationManagerDelegate, HandleMapSearch, MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    WeatherResponseParser * sharedObject;
    NSString* latitude;
    NSString* longitude;
    int numberOfDays;
}
@property (weak, nonatomic) IBOutlet UIView *vw_UserSelection;
@property (weak, nonatomic) IBOutlet UITextField *txtToLocation;
- (IBAction)submitBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *datePicketText;
@property (weak, nonatomic) IBOutlet UITableView *weatherDisplay;

@end

