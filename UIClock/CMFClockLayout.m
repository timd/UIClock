//
//  CMFClockLayout.m
//  UIClock
//
//  Created by Tim on 10/10/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMFClockLayout.h"
#import "CMFClockViewAttributes.h"

@interface CMFClockLayout ()
@property (nonatomic) CGPoint cvCenter;
@property (nonatomic) NSInteger hoursCount;
@property (nonatomic) NSInteger timeHours;
@property (nonatomic) NSInteger timeMinutes;
@property (nonatomic) NSInteger timeSeconds;
@end

@implementation CMFClockLayout

-(id)init {
    self = [super init];
    if (self) {
        // Configure
    }
    return self;
}

+(Class)layoutAttributesClass {
    return [CMFClockViewAttributes class];
}

-(void)prepareLayout {
    self.cvCenter = CGPointMake(self.layoutCollectionView.frame.size.width /2, self.layoutCollectionView.frame.size.height/2);
    self.hoursCount = [self.collectionView numberOfItemsInSection:0];
    
    NSDateFormatter *hoursFormatter = [[NSDateFormatter alloc] init];
    [hoursFormatter setDateFormat:@"hh"];
    NSString *hourString = [hoursFormatter stringFromDate:self.time];
    self.timeHours = [hourString integerValue];
    
    NSDateFormatter *minsFormatter = [[NSDateFormatter alloc] init];
    [minsFormatter setDateFormat:@"mm"];
    NSString *minString = [minsFormatter stringFromDate:self.time];
    self.timeMinutes = [minString integerValue];

    NSDateFormatter *secsFormatter = [[NSDateFormatter alloc] init];
    [secsFormatter setDateFormat:@"ss"];
    NSString *secString = [secsFormatter stringFromDate:self.time];
    self.timeSeconds = [secString integerValue];
    
}

-(CGSize)collectionViewContentSize {
    return self.layoutCollectionView.frame.size;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributesArray = [[NSMutableArray alloc] init];

    // Iterate across all rows in each section
    for (NSInteger section=0; section < [self.collectionView numberOfSections] ; section++) {

        for (NSInteger item=0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            
            // Get attributes
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [attributesArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            
        }
        
    }
    
    return attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMFClockViewAttributes *attributes = [CMFClockViewAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        // Handle hours labels
        attributes.size = CGSizeMake(60.0f, 60.0f);
        attributes.center = [self calculatePositionForHourLabelWithIndexPath:indexPath];
    }
    
    if (indexPath.section == 1) {
        // deal with hands
        
        float angularDisplacement;
        float rotationPerHour = ((2*M_PI) / 12);
        float rotationPerMinute = ((2*M_PI) / 60);
        
        switch (indexPath.row) {
            case 0:
//                // Handle hour hands
                attributes.size = self.hourHandSize;
                attributes.center = self.cvCenter;
                
                float intraHourRotationPerMinute = rotationPerHour / 60;
                float currentIntraHourRotation = intraHourRotationPerMinute * self.timeMinutes;
                angularDisplacement =  (rotationPerHour * self.timeHours) + currentIntraHourRotation;
                
                attributes.transform = CGAffineTransformMakeRotation(angularDisplacement);
                break;

            case 1:
//                // Handle minute hands
                attributes.size = self.minuteHandSize;
                attributes.center = self.cvCenter;
                
                float intraMinuteRotationPerSecond = rotationPerMinute / 60;
                float currentIntraMinuteRotation = intraMinuteRotationPerSecond * self.timeSeconds;
                angularDisplacement =  (rotationPerMinute * self.timeMinutes) + currentIntraMinuteRotation;

                attributes.transform = CGAffineTransformMakeRotation(angularDisplacement);
                break;

            case 3:
                // Handle second hands
                attributes.size = self.secondHandSize;
                attributes.center = self.cvCenter;

                angularDisplacement =  rotationPerMinute * self.timeSeconds;
                attributes.transform = CGAffineTransformMakeRotation(angularDisplacement);

                break;
                
            default:
                break;
        }
        
    }
    
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(CGPoint)calculatePositionForHourLabelWithIndexPath:(NSIndexPath *)indexPath {
    
    // Calculate
    float angularDisplacement = (2 * M_PI) / self.hoursCount;
    
    float initialDisplacement = angularDisplacement;
    
    float theta = (angularDisplacement * indexPath.row) + initialDisplacement;
    
    float xDisplacement = sinf(theta) * 250;
    float yDisplacement = cosf(theta) * 250;
    
    CGPoint center = CGPointMake(self.cvCenter.x + xDisplacement, self.cvCenter.y - yDisplacement);
    
    return center;
}

@end
