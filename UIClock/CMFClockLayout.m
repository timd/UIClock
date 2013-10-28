//
//  CMFClockLayout.m
//  UIClock
//
//  Created by Tim on 10/10/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMFClockLayout.h"

@interface CMFClockLayout ()
@property (nonatomic, strong) NSMutableArray *attributesArray;
@property (nonatomic) CGPoint cvCenter;
@property (nonatomic) NSInteger hoursCount;
@property (nonatomic) NSInteger timeHours;
@property (nonatomic) NSInteger timeMinutes;
@property (nonatomic) NSInteger timeSeconds;
@end

const float CMHourLabelCellWidth = 60.0f;
const float CMHourLabelCellHeight = 60.0f;
const float CMClockFaceRadius = 250.0f;

@implementation CMFClockLayout

#pragma mark -
#pragma mark Object lifecycle

-(id)init {
    self = [super init];
    if (self) {
        // Instantiate the attributes array
        self.attributesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark UICollectionViewLayout methods

-(void)prepareLayout {

    // Layout dimensions calculations
    self.cvCenter = CGPointMake(self.collectionView.frame.size.width /2, self.collectionView.frame.size.height/2);
    self.hoursCount = [self.collectionView numberOfItemsInSection:0];

    // Extract the current time settings from the time property
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
    
    // Clear the attributesArray if there are any contents
    if ([self.attributesArray count] != 0) {
        [self.attributesArray removeAllObjects];
    }
    
    // Force re-calculation of the attributes en-masse
    [self calculateAllAttributes];
    
}

-(CGSize)collectionViewContentSize {
    // Content size is the same as the collection view size
    return self.collectionView.frame.size;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // Return all the attributes
    return self.attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Find the attribute in the attributesArray with the corresponding indexPath
    NSInteger index = [self.attributesArray indexOfObjectPassingTest:^BOOL(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        NSComparisonResult result = [attributes.indexPath compare:indexPath];
        return (result == NSOrderedSame);
    }];
    
    if (index != NSNotFound) {
        return [self.attributesArray objectAtIndex:index];
    }
    
    // If no attribute is found, then
    // things have gone horribly wrong
    return nil;
    
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // Placeholder method
    return nil;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    // Placeholder method
    return nil;
}

#pragma mark -
#pragma mark Custom methods

-(void)calculateAllAttributes {
    
    // This method iterates across all rows in each section of the collection view's data model
    // and calculates an attributes set for each one.
    for (NSInteger section=0; section < [self.collectionView numberOfSections] ; section++) {
        
        for (NSInteger item=0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            
            // Calculate attributes
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self calculateAttributesForItemAtIndexPath:indexPath];
            
        }
        
    }
    
}


-(void)calculateAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Calculate the attributes for a given index path
    UICollectionViewLayoutAttributes *attributes = nil;
    
    // Handle hours labels
    if (indexPath.section == 0) {
        attributes = [self calculateAttributesForHourLabelWithIndexPath:indexPath];
    }

    // deal with hands
    if (indexPath.section == 1) {
        attributes = [self calculateAttributesForHandCellAtIndexPath:indexPath];
    }
    
    // Find the attributes objects with matching index path in the attributesArray
    NSInteger index = [self.attributesArray indexOfObjectPassingTest:^BOOL(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        NSComparisonResult result = [attributes.indexPath compare:indexPath];
        return (result == NSOrderedSame);
    }];
    
    // If an existing index path was found, overwrite the attributes with the newly-calculated set
    // Otherwise, add these to the attributesArray
    if (index != NSNotFound) {
        [self.attributesArray insertObject:attributes atIndex:index];
    } else {
        [self.attributesArray addObject:attributes];
    }
    
}

#pragma mark -
#pragma mark Hour label calculations

-(UICollectionViewLayoutAttributes *)calculateAttributesForHourLabelWithIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // Calculates the position of hour labels around the clock face
    // Handle hours labels
    attributes.size = CGSizeMake(CMHourLabelCellWidth, CMHourLabelCellHeight);
    
    // Calculate angular displacement from zero degrees,
    // at 360 / 12 degrees per hour
    float angularDisplacement = (2 * M_PI) / self.hoursCount;
    
    // Calculate current rotation
    float theta = (angularDisplacement * indexPath.row);
    
    // Trig to calculate the x and 7 shifts required to
    // get the hours displayed around a circle of
    // diameter 250 points
    float xDisplacement = sinf(theta) * CMClockFaceRadius;
    float yDisplacement = cosf(theta) * CMClockFaceRadius;
    
    // Make the centre point of the hour label block
    CGPoint center = CGPointMake(self.cvCenter.x + xDisplacement,
                                 self.cvCenter.y - yDisplacement);
    
    attributes.center = center;
    
    return attributes;
    
}

#pragma mark -
#pragma mark Hand cell calculations

-(UICollectionViewLayoutAttributes *)calculateAttributesForHandCellAtIndexPath:(NSIndexPath *)indexPath {
    
    // Calculate the position of the hands
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    float angularDisplacement;
    float rotationPerHour = ((2*M_PI) / 12);
    float rotationPerMinute = ((2*M_PI) / 60);
    
    switch (indexPath.row) {
        case 0:
            // Handle hour hands
            attributes.size = self.hourHandSize;
            attributes.center = self.cvCenter;
            
            float intraHourRotationPerMinute = rotationPerHour / 60;
            float currentIntraHourRotation = intraHourRotationPerMinute * self.timeMinutes;
            angularDisplacement =  (rotationPerHour * self.timeHours) + currentIntraHourRotation;
            attributes.transform = CGAffineTransformMakeRotation(angularDisplacement);
            break;
            
        case 1:
            // Handle minute hands
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
    
    return attributes;
    
}

#pragma mark -
#pragma mark Placeholder methods

-(void)calculateAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // Placeholder method
}

-(void)calculateAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    // Placeholder method
}

@end
