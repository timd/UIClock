//
//  CMFViewController.m
//  UIClock
//
//  Created by Tim on 10/10/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMFViewController.h"
#import "CMFClockLayout.h"

@interface CMFViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CMFClockLayout *clockLayout;
@end

static NSString *const kHourCellView = @"HourCellView";
static NSString *const kHourHandCell = @"HourHandCell";
static NSString *const kMinsHandCell = @"MinsHandCell";
static NSString *const kSecsHandCell = @"SecsHandCell";


@implementation CMFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupData];
    [self configureCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Setup methods

-(void)setupData {
    
    NSMutableArray *hoursArray = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"]];
    NSArray *handsArray = @[@"hours", @"minutes", @"seconds"];
    
    self.dataArray = [NSMutableArray arrayWithObjects:hoursArray, handsArray, nil];
    
}

-(void)configureCollectionView {

    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFHourLabelView" bundle:nil] forCellWithReuseIdentifier:kHourCellView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFHourHand" bundle:nil] forCellWithReuseIdentifier:kHourHandCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFMinHand" bundle:nil] forCellWithReuseIdentifier:kMinsHandCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFSecondHand" bundle:nil] forCellWithReuseIdentifier:kSecsHandCell];
    
    self.clockLayout = [[CMFClockLayout alloc] init];
    [self.clockLayout setLayoutCollectionView:self.collectionView];
    [self.collectionView setCollectionViewLayout:self.clockLayout];
    
}

#pragma mark -
#pragma mark UICollectionView methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSArray *innerArray = [self.dataArray objectAtIndex:section];
    
    return [innerArray count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        // Handle time labels
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kHourCellView forIndexPath:indexPath];
        
        NSArray *hoursLabelsArray = [self.dataArray objectAtIndex:0];
        NSString *hoursText = [hoursLabelsArray objectAtIndex:indexPath.row];
        
        UILabel *hoursLabel = (UILabel *)[cell viewWithTag:1000];
        [hoursLabel setText:hoursText];

    }
    
    if (indexPath.section == 1) {
        
            switch (indexPath.row) {
                case 0:
                    // Handle hour hands
                    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kHourHandCell forIndexPath:indexPath];
                    break;

                case 1:
                    // Handle minute hands
                    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kMinsHandCell forIndexPath:indexPath];
                    break;

                case 2:
                    // Handle second hands
                    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kSecsHandCell forIndexPath:indexPath];
                    break;

                default:
                    break;
            }

    }
    
    return cell;

}

@end
