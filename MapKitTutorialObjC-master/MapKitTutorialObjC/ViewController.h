//
//  ViewController.h
//  HackathonTravelPlanner
//
//  Created by IBM on 04/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//


#import <UIKit/UIKit.h>
@import MapKit;

@protocol HandleMapSearch <NSObject>
- (void)dropPinZoomIn:(MKPlacemark *)placemark;
@end

@interface ViewController : UIViewController <CLLocationManagerDelegate, HandleMapSearch, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *vw_UserSelection;

@end

