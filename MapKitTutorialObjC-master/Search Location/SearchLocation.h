//
//  SearchLocation.h
//  MapKitTutorialObjC
//
//  Created by Biswabaran Mukherjee on 07/08/16.
//  Copyright © 2016 Robert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SearchLocation : UIViewController{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_locationSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchLocation;
@property id <HandleMapSearch>handleMapSearchDelegate;
@property MKMapView *mapView;
@property(nonatomic) int selectedTextFieldTag;
- (IBAction)cancelBtnClick:(id)sender;

@end
