//
//  FetchWeatherData.h
//  HackathonTravelPlanner
//
//  Created by IBM on 04/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchWeatherData : NSObject<NSURLSessionDelegate>{
    
}
+ (id) sharedManager;
-(void) startWeatherDataDownLoad:(NSString*)latitude withLongitude:(NSString*)longitude;
-(NSDictionary*) getParsedDictionary;

@end
