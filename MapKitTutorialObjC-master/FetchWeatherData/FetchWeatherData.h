//
//  FetchWeatherData.h
//  HackathonTravelPlanner
//
//  Created by IBM on 04/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WeatherDataFetchedDelegate <NSObject>
@required
-(void) weatherDataDownloadedSuccess;
@end

@interface FetchWeatherData : NSObject<NSURLSessionDelegate>{
    id <WeatherDataFetchedDelegate> delegate;
}
@property (nonatomic,weak) id delegate;
+ (id) sharedManager;
-(void) startWeatherDataDownLoad:(NSString*)latitude withLongitude:(NSString*)longitude withNumberOfDays:(int)days;
-(NSDictionary*) returnParsedDictionary;
@end
