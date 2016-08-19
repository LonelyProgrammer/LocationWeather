//
//  WeatherResponseParser.m
//  HackathonTravelPlanner
//
//  Created by Rishi Bhattacharjee on 04/08/16.
//  Copyright © 2016 Robert Chen. All rights reserved.
//

#import "WeatherResponseParser.h"

@implementation WeatherResponseParser

+ (id)sharedManager {
    static FetchWeatherData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
         sharedObject = [FetchWeatherData sharedManager];
        sharedObject.delegate = self;
    }
    return self;
}

-(void) startWeatherDataDownLoad:(NSString*)latitude withLongitude:(NSString*)longitude withNumberOfDays:(int)days{
    [sharedObject startWeatherDataDownLoad:latitude withLongitude:longitude withNumberOfDays:days];
}

#pragma mark - Sample protocol delegate
-(void) weatherDataDownloadedSuccess{
        NSMutableDictionary* initialParsedDictionary =  [NSMutableDictionary dictionaryWithDictionary:[sharedObject returnParsedDictionary]];
         finalParsedDictionary = [initialParsedDictionary valueForKey:@"forecasts"];
        [self.delegate weatherDataParseSuccess];
}

-(NSDictionary*)returnFinalParsedDictionary{
    return finalParsedDictionary;
}
-(void)weatherDataParseSuccess{
    NSLog(@"Parsing Successful!!!");
}
@end
