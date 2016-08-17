//
//  ViewController.m
//  HackathonTravelPlanner
//
//  Created by IBM on 04/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//


#import "ViewController.h"
//#import "LocationSearchTable.h"
#import "UserLocationDetails.h"
#import "SearchLocation.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray *arrUserLocation;

@end

@implementation ViewController

CLLocationManager *locationManager;
UISearchController *resultSearchController;
MKPlacemark *selectedPin;

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObject = [[WeatherResponseParser sharedManager]init];
    //[sharedObject startWeatherDataDownLoad];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openUserSelection) name:@"UserSelecton" object:nil];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestLocation];
    [locationManager requestWhenInUseAuthorization];
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
   // LocationSearchTable *locationSearchTable = [storyboard instantiateViewControllerWithIdentifier:@"LocationSearchTable"];
    //resultSearchController = [[UISearchController alloc] initWithSearchResultsController:locationSearchTable];
//    resultSearchController.searchResultsUpdater = locationSearchTable;
//    
//    UISearchBar *searchBar = resultSearchController.searchBar;
//    [searchBar sizeToFit];
//    searchBar.placeholder = @"Search for places";
//    self.navigationItem.titleView = resultSearchController.searchBar;
//    
//    resultSearchController.hidesNavigationBarDuringPresentation = NO;
//    resultSearchController.dimsBackgroundDuringPresentation = YES;
//    self.definesPresentationContext = YES;
//
//    locationSearchTable.mapView = _mapView;
//
//    locationSearchTable.handleMapSearchDelegate = self;
    self.title = @"Weather Tracker";
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(userSelectionOpen:)];
    [searchButton setImage:[UIImage imageNamed:@"search"]];
    
    self.navigationItem.rightBarButtonItem = searchButton;

}

-(void)openUserSelection{
    _vw_UserSelection.hidden = NO;
}

-(IBAction)userSelectionOpen:(id)sender{
    _vw_UserSelection.hidden = NO;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    NSString* latitude = [NSString stringWithFormat:@"%g", location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%g", location.coordinate.longitude];
   
    //Get the weather Info based on latitude and Longitude
    [sharedObject startWeatherDataDownLoad:latitude withLongitude:longitude];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    [temp addObject:latitude];
    [temp addObject:longitude];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region animated:true];
}

- (void)dropPinZoomIn:(MKPlacemark *)placemark :(int)Tag
{
    UserLocationDetails *userLocationDetails = [[UserLocationDetails alloc]init];
    userLocationDetails.userplacemark = (MKPlacemark *)placemark;
    userLocationDetails.locationID = Tag;
    [_arrUserLocation addObject:userLocationDetails];
    
    
    if (Tag == 1) {
        _txtFromLocation.text = placemark.name;
    }
    else if(Tag == 2){
        _txtToLocation.text = placemark.name;
    }
    
    
    
    
    // cache the pin
    selectedPin = placemark;
    // clear existing pins
    [_mapView removeAnnotations:(_mapView.annotations)];
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = placemark.coordinate;
    annotation.title = placemark.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@ %@",
                           (placemark.locality == nil ? @"" : placemark.locality),
                           (placemark.administrativeArea == nil ? @"" : placemark.administrativeArea)
                           ];
    [_mapView addAnnotation:annotation];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(placemark.coordinate, span);
    [_mapView setRegion:region animated:true];
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //return nil so map view draws "blue dot" for standard user location
        return nil;
    }
    
    static NSString *reuseId = @"pin";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
        pinView.tintColor = [UIColor orangeColor];
    } else {
        pinView.annotation = annotation;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"car"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getDirections) forControlEvents:UIControlEventTouchUpInside];
    pinView.leftCalloutAccessoryView = button;
    
    return pinView;
}

- (void)getDirections {
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:selectedPin];
    [mapItem openInMapsWithLaunchOptions:(@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving})];
}

#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SearchLocation *locationSearchTable = [storyboard instantiateViewControllerWithIdentifier:@"SearchLocation"];
    locationSearchTable.handleMapSearchDelegate = self;
    locationSearchTable.selectedTextFieldTag = (int)textField.tag;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self presentViewController:locationSearchTable animated:YES completion:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

#pragma mark ---Button actions

- (IBAction)submitBtnClick:(id)sender {
    _vw_UserSelection.hidden = YES;
}

@end
