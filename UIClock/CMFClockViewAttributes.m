//
//  CMFClockViewAttributes.m
//  UIClock
//
//  Created by Tim on 10/10/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMFClockViewAttributes.h"

@implementation CMFClockViewAttributes

- (id)copyWithZone:(NSZone *)zone {
    CMFClockViewAttributes *copy = [super copyWithZone:zone];
    copy.layer = self.layer;
    return copy;
}

@end
