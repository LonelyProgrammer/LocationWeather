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

-(void) startWeatherDataDownLoad:(NSString*)latitude withLongitude:(NSString*)longitude{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString* urlString = [NSString stringWithFormat:
                           @"https://api.weather.com/v1/geocode/%@/%@/forecast/daily/3day.json?language=en-US&units=e&apiKey=%@",latitude,longitude,weatherApiKey];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        parsedJsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"The parsed Json is =%@", parsedJsonDictionary);
    }];
    [dataTask resume];
}

-(NSDictionary*) getParsedDictionary{
    return parsedJsonDictionary;
}

@end
