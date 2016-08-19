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
#import "MapPoint.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray *arrUserLocation;

@end

@implementation ViewController

CLLocationManager *locationManager;
UISearchController *resultSearchController;
MKPlacemark *selectedPin;
BOOL poiClicked;
NSString *buttonTitleUppercase;

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObject = [[WeatherResponseParser sharedManager]init];
    sharedObject.delegate = self;
    self.weatherDisplay.hidden = YES;
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openUserSelection) name:@"UserSelecton" object:nil];
    numberOfDays = 0;
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.datePicketText setInputView:datePicker];
    [self.datePicketText setPlaceholder:@"Maximum 10 days from current date"];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestLocation];
    [locationManager requestWhenInUseAuthorization];
    
    self.title = @"Weather Tracker";
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain
                                                                    target:self action:@selector(userSelectionOpen:)];
    [searchButton setImage:[UIImage imageNamed:@"search"]];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
    [self hideUnhidePOI:YES];
    
}

-(void)openUserSelection{
    _vw_UserSelection.hidden = NO;
}

-(IBAction)userSelectionOpen:(id)sender{
    if(_vw_UserSelection.hidden)
        _vw_UserSelection.hidden = NO;
    else
        _vw_UserSelection.hidden = YES;
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
     latitude = [NSString stringWithFormat:@"%g", location.coordinate.latitude];
     longitude = [NSString stringWithFormat:@"%g", location.coordinate.longitude];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    [temp addObject:latitude];
    [temp addObject:longitude];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region animated:true];
}

- (void)dropPinZoomIn:(MKPlacemark *)placemark :(int)Tag
{
    [self hideUnhidePOI:NO];
    globalPlacemark = placemark;
    UserLocationDetails *userLocationDetails = [[UserLocationDetails alloc]init];
    userLocationDetails.userplacemark = (MKPlacemark *)placemark;
    userLocationDetails.locationID = Tag;
    [_arrUserLocation addObject:userLocationDetails];
    _txtToLocation.text = placemark.name;
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
    
    if (!poiClicked) {
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
        
    }
    else{
        if (pinView == nil) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            pinView.enabled = YES;
            pinView.canShowCallout = YES;
            pinView.tintColor = [UIColor blueColor];
        } else {
            pinView.tintColor = [UIColor colorWithRed:196.0/255.0f green:96.0/255.0f blue:46.0/255.0f alpha:1.0];
            pinView.annotation = annotation;
        }
        
        UIImageView *imgAccessoryVw = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgAccessoryVw.image = [UIImage imageNamed:buttonTitleUppercase];
        pinView.leftCalloutAccessoryView = imgAccessoryVw;
        
    }
    
    
    
    
    
    return pinView;
}

- (void)getDirections {
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:selectedPin];
    [mapItem openInMapsWithLaunchOptions:(@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving})];
}

#pragma mark ---Table View Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return weatherData.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    static NSString *CellIdentifier = @"Cell";
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
////    cell.textLabel.text = ;
////    cell.detailTextLabel.text = prod.parent;
////    cell.indentationLevel = prod.level;
////    cell.indentationWidth = indendationWidth;
////    // Show disclosure only if the cell can expand
////    if(prod.canBeExpanded)
////    {
////        cell.accessoryView = [self viewForDisclosureForState:YES];
////    }
////    else
////    {
////        //cell.accessoryType = UITableViewCellAccessoryNone;
////        cell.accessoryView = nil;
////    }
////    // Configure the cell...
////    
////    return cell;
//}

-(UIView*) viewForDisclosureForState:(BOOL) isExpanded
{
    NSString *imageName;
    if(isExpanded)
    {
        imageName = @"ArrowD_blue.png";
    }
    else
    {
        imageName = @"ArrowR_blue.png";
    }
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imgView setFrame:CGRectMake(0, 6, 24, 24)];
    [myView addSubview:imgView];
    return myView;
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
    if (_txtToLocation.text.length > 0 && _datePicketText.text.length > 0) {
        poiClicked = NO;
        _vw_UserSelection.hidden = YES;
        self.weatherDisplay.hidden = NO;
        [self dropPinZoomIn:globalPlacemark :1];
        //Get the weather Info based on latitude and Longitude
        [sharedObject startWeatherDataDownLoad:latitude withLongitude:longitude withNumberOfDays:numberOfDays];
    }
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:nil
                                      message:@"Please input your travel location and the date of journey to get the weather forecast."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [vc presentViewController:alert animated:YES completion:nil];
    }
    
}

-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.datePicketText.inputView;
    [picker setMinimumDate:[NSDate date]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:10];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];

    [picker setMaximumDate:maxDate];
    comps = nil;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    self.datePicketText.text = [NSString stringWithFormat:@"%@",dateString];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                                        fromDate:currentDate
                                                          toDate:eventDate
                                                         options:0];
    numberOfDays = (int)[components day];
    [self.datePicketText resignFirstResponder];
}

<<<<<<< HEAD
#pragma mark ---Singleton Delegates

-(void) weatherDataParseSuccess{
    self.weatherDisplay.delegate = self;
    self.weatherDisplay.dataSource = self;
    weatherData = [sharedObject returnFinalParsedDictionary] ;
    [self.weatherDisplay reloadData];
    
=======

#pragma mark --
#pragma mark Place Of Interest
- (IBAction)POIClick:(id)sender {
    poiClicked = YES;
    UIButton *btn = (UIButton*)sender;
    buttonTitleUppercase = btn.titleLabel.text;
    NSString *buttonTitle = [btn.titleLabel.text lowercaseString];
    
    //Use this title text to build the URL query and get the data from Google. Change the radius value to increase the size of the search area in meters. The max is 50,000.
    [self queryGooglePlaces:buttonTitle];
}


-(void) queryGooglePlaces: (NSString *) googleType
{
    
    
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=10000&types=%@&sensor=true&key=%@", globalPlacemark.coordinate.latitude, globalPlacemark.coordinate.longitude, googleType, kGOOGLE_API_KEY];
    //NSString *url = @"https://maps.googleapis.com/maps/api/place/search/json?location=22.0522,88.2437&radius=2619408&types=bar&sensor=true&key=AIzaSyAZD2Wwnyh-dk6o1l_m3vrYu7r2DtfOQnU";
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}


- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
    
    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:places];
    
    
}



- (void)plotPositions:(NSArray *)data
{
    //Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in _mapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    
    //Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        
        
        [_mapView addAnnotation:placeObject];
    }
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
        
    MKCoordinateSpan span = MKCoordinateSpanMake(5.05, 5.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(globalPlacemark.coordinate, span);
    [_mapView setRegion:region animated:true];
    
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];
    
}



-(void)hideUnhidePOI:(BOOL)status{
    _lbl_poi.hidden = status;
    _btn_bar.hidden = status;
    _btn_atm.hidden = status;
    _btn_cafe.hidden = status;
    _btn_park.hidden = status;
    _btn_florist.hidden = status;
>>>>>>> origin/master
}

@end
