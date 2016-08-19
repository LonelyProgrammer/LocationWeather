//
//  AccordianTableViewHelper.m
//  HackathonTravelPlanner
//
//  Created by Rishi Bhattacharjee on 19/08/16.
//  Copyright © 2016 IBM. All rights reserved.
//

#import "AccordianTableViewHelper.h"

@implementation AccordianTableViewHelper

-(NSMutableArray*)children
{
    if (!_children) {
        _children = [[NSMutableArray alloc] init];
    }
    return _children;
}

@end
