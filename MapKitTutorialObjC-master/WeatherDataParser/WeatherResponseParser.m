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
    }
    return self;
}

-(void) startWeatherDataDownLoad{
    [sharedObject startWeatherDataDownLoad];
}
@end
