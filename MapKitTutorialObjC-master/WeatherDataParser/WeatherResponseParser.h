//
//  WeatherResponseParser.h
//  HackathonTravelPlanner
//
//  Created by Rishi Bhattacharjee on 04/08/16.
//  Copyright © 2016 Robert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchWeatherData.h"

@protocol WeatherDataParseDelegate<NSObject>
@required
-(void) weatherDataParseSuccess;
@end

@interface WeatherResponseParser : NSObject<WeatherDataFetchedDelegate>{
    FetchWeatherData* sharedObject;
    NSDictionary* finalParsedDictionary;
     id <WeatherDataParseDelegate> delegate;
}
@property (nonatomic,weak) id delegate;
-(NSDictionary*)returnFinalParsedDictionary;
-(void) startWeatherDataDownLoad:(NSString*)latitude withLongitude:(NSString*)longitude withNumberOfDays:(int)days;
+ (id)sharedManager;

@end
