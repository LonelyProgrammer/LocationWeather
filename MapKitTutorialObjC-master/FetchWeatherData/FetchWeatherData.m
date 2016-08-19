//
//  FetchWeatherData.m
//  HackathonTravelPlanner
//
//  Created by IBM on 04/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//

#import "FetchWeatherData.h"
#define weatherApiKey @"a8a442883637a90641c0bb3d92a3bc46"

@implementation FetchWeatherData{
    NSDictionary *parsedJsonDictionary;
}
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
    }
    return self;
}

-(void) startWeatherDataDownLoad:(NSString*)latitude withLongitude:(NSString*)longitude withNumberOfDays:(int)days{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString* urlString;
    switch (days) {
        case 1:
        case 2:
            urlString = [NSString stringWithFormat:
                         @"https://api.weather.com/v1/geocode/%@/%@/observations/current.json?language=en-US&units=e&apiKey=%@",latitude,longitude,weatherApiKey];
            
            break;
            
        case 3:
        case 4:{
            urlString = [NSString stringWithFormat:
                         @"https://api.weather.com/v1/geocode/%@/%@/forecast/daily/%dday.json?language=en-US&units=e&apiKey=%@",latitude,longitude,3,weatherApiKey];
        }
            break;
            
        case 5:
        case 6:{
            urlString = [NSString stringWithFormat:
                         @"https://api.weather.com/v1/geocode/%@/%@/forecast/daily/%dday.json?language=en-US&units=e&apiKey=%@",latitude,longitude,5,weatherApiKey];
        }
            break;
            
        case 7:
        case 8:{
            urlString = [NSString stringWithFormat:
                         @"https://api.weather.com/v1/geocode/%@/%@/forecast/daily/%dday.json?language=en-US&units=e&apiKey=%@",latitude,longitude,7,weatherApiKey];
        }
            break;
            
        case 9:
        case 10:
        case 11:{
            urlString = [NSString stringWithFormat:
                         @"https://api.weather.com/v1/geocode/%@/%@/forecast/daily/%dday.json?language=en-US&units=e&apiKey=%@",latitude,longitude,10,weatherApiKey];
        }
            break;
            
        default:
            urlString = [NSString stringWithFormat:
                         @"https://api.weather.com/v1/geocode/%@/%@/observations/current.json?language=en-US&units=e&apiKey=%@",latitude,longitude,weatherApiKey];

            break;
    }

    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        parsedJsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.delegate weatherDataDownloadedSuccess];
    }];
    [dataTask resume];
}

-(void) weatherDataDownloadedSuccess{
    NSLog(@"The parsed Json is =%@", parsedJsonDictionary);
}
-(NSDictionary*) returnParsedDictionary{
    return parsedJsonDictionary;
}

@end
