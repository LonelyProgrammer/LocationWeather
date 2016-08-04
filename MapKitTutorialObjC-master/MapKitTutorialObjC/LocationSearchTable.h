//
//  LocationSearchTable.h
//  HackathonTravelPlanner
//
//  Created by IBM on 04/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//


#import <UIKit/UIKit.h>
@import MapKit;
#import "ViewController.h"

@interface LocationSearchTable : UITableViewController <UISearchResultsUpdating>
@property MKMapView *mapView;
@property id <HandleMapSearch>handleMapSearchDelegate;

@end
