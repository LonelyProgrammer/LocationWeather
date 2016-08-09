//
//  UserLocationDetails.h
//  MapKitTutorialObjC
//
//  Created by Biswabaran Mukherjee on 07/08/16.
//  Copyright © 2016 Robert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface UserLocationDetails : NSObject{
    
}

@property(nonatomic, assign) MKPlacemark *userplacemark;
@property (nonatomic) int locationID;

@end
