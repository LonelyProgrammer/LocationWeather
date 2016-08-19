//
//  AccordianTableViewHelper.h
//  HackathonTravelPlanner
//
//  Created by Rishi Bhattacharjee on 19/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    
    OBJECT_TYPE_REGION =0,
    OBJECT_TYPE_LOCATION,
    OBJECT_TYPE_USERS
    
    
} ObjectType;
@interface AccordianTableViewHelper : NSObject{
    
}
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *parent;
@property(nonatomic) BOOL canBeExpanded;
@property(nonatomic) BOOL isExpanded;
@property(nonatomic) NSInteger level;
@property(nonatomic) int type;
@property(nonatomic, strong) NSMutableArray *children;
@end
