//
//  SearchLocation.m
//  MapKitTutorialObjC
//
//  Created by Biswabaran Mukherjee on 07/08/16.
//  Copyright © 2016 Robert Chen. All rights reserved.
//

#import "SearchLocation.h"

@interface SearchLocation ()
@property NSArray<MKMapItem *> *matchingLocationItems;
@end

@implementation SearchLocation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Search Location";
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *searchBarText = textField.text;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBarText;
    request.region = _mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.matchingLocationItems = [NSMutableArray arrayWithArray:response.mapItems];
        [_tbl_locationSearch reloadData];
    }];
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_matchingLocationItems count];
}

- (NSString *)parseAddress:(MKPlacemark *)selectedItem {
    // put a space between "4" and "Melrose Place"
    NSString *firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? @" " : @"";
    // put a comma between street and city/state
    NSString *comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? @", " : @"";
    // put a space between "Washington" and "DC"
    NSString *secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? @" " : @"";
    NSString *addressLine = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             (selectedItem.subThoroughfare == nil ? @"" : selectedItem.subThoroughfare),
                             firstSpace,
                             (selectedItem.thoroughfare == nil ? @"" : selectedItem.thoroughfare),
                             comma,
                             // city
                             (selectedItem.locality == nil ? @"" : selectedItem.locality),
                             secondSpace,
                             // state
                             (selectedItem.administrativeArea == nil ? @"" : selectedItem.administrativeArea)
                             ];
    return addressLine;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MKPlacemark *selectedItem = (MKPlacemark*)_matchingLocationItems[indexPath.row].placemark;
    cell.textLabel.text = selectedItem.name;
    cell.detailTextLabel.text = [self parseAddress:selectedItem];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKPlacemark *selectedItem = _matchingLocationItems[indexPath.row].placemark;
    //[_handleMapSearchDelegate dropPinZoomIn:(selectedItem)];
    [_handleMapSearchDelegate dropPinZoomIn:(selectedItem) :_selectedTextFieldTag];
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
