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
   
    switch (days) {
        case 1:
        case 2:
            numberOfDays = 0;
            
            break;
            
        case 3:
        case 4:
            numberOfDays = 3;
            break;
            
        case 5:
        case 6:
            numberOfDays = 5;
            break;
            
        case 7:
        case 8:
            numberOfDays = 7;
            break;
        case 9:
        case 10:
        case 11:
            numberOfDays = 10;
            break;
            
        default:
            numberOfDays = 0;
            
            break;
    }

    [sharedObject startWeatherDataDownLoad:latitude withLongitude:longitude withNumberOfDays:numberOfDays];
}

#pragma mark - Sample protocol delegate
-(void) weatherDataDownloadedSuccess{
    NSMutableDictionary* initialParsedDictionary =  [NSMutableDictionary dictionaryWithDictionary:[sharedObject returnParsedDictionary]];
    if([initialParsedDictionary valueForKey:@"forecasts"])
        finalParsedDictionary = [initialParsedDictionary valueForKey:@"forecasts"];
    else{
        finalParsedDictionary = [initialParsedDictionary valueForKey:@"observation"];
    }
    [self.delegate weatherDataParseSuccess];
}

-(NSDictionary*)returnFinalParsedDictionary{
    return finalParsedDictionary;
}

-(int)returnNumberOfDays{
    return numberOfDays;
}
-(void)weatherDataParseSuccess{
    NSLog(@"Parsing Successful!!!");
}
@end
