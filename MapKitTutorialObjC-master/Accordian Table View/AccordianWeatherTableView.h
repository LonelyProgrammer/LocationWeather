//
//  AccordianWeatherTableView.h
//  HackathonTravelPlanner
//
//  Created by Rishi Bhattacharjee on 19/08/16.
//  Copyright © 2016 Robert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccordianTableViewHelper.h"
#import "WeatherResponseParser.h"

@interface AccordianWeatherTableView : UITableViewController{
    NSMutableArray* arraySingleEntryValues;
    NSMutableArray* arraySingleEntryKeys;
    NSMutableArray* arrayMultipleEntry;
    NSMutableArray *dataArray;
    NSInteger indentationlevel;
    CGFloat indendationWidth;
    int numberOfDays;
}

@end
