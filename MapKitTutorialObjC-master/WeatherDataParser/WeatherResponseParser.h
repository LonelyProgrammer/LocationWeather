//
//  WeatherResponseParser.h
//  HackathonTravelPlanner
//
//  Created by Rishi Bhattacharjee on 04/08/16.
//  Copyright © 2016 Robert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchWeatherData.h"

@interface WeatherResponseParser : NSObject{
    FetchWeatherData* sharedObject;
}
-(void) startWeatherDataDownLoad;
+ (id)sharedManager;

@end
