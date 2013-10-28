//
//  CMFClockLayout.h
//  UIClock
//
//  Created by Tim on 10/10/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMFClockLayout : UICollectionViewLayout

@property (nonatomic, strong) NSDate *time;

@property (nonatomic) CGSize secondHandSize;
@property (nonatomic) CGSize minuteHandSize;
@property (nonatomic) CGSize hourHandSize;

@end
