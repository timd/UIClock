//
//  CMFClockLayout.m
//  UIClock
//
//  Created by Tim on 10/10/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMFClockLayout.h"

@interface CMFClockLayout ()
@property (nonatomic) CGPoint cvCenter;
@property (nonatomic) NSInteger hoursCount;
@end

@implementation CMFClockLayout

-(id)init {
    self = [super init];
    if (self) {
        // Configure
    }
    return self;
}

-(void)prepareLayout {
    self.cvCenter = CGPointMake(self.layoutCollectionView.frame.size.width /2, self.layoutCollectionView.frame.size.height/2);
    self.hoursCount = [self.collectionView numberOfItemsInSection:0];
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
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        // Handle hours labels
        attributes.size = CGSizeMake(50.0f, 50.0f);
        attributes.center = [self calculatePositionForHourLabelWithIndexPath:indexPath];
        
    }
    
    if (indexPath.section == 1) {
        // deal with hands
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
