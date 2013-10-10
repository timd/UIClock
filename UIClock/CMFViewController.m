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
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
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
    [self updateClock];
    
    // Define the timer object
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark -
#pragma mark Setup methods

-(void)setupData {
    
    NSMutableArray *hoursArray = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"]];
    NSArray *handsArray = @[@"hours", @"minutes", @"", @"seconds"];
    
    self.dataArray = [NSMutableArray arrayWithObjects:hoursArray, handsArray, nil];
    
}

-(void)configureCollectionView {

    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFHourLabelView" bundle:nil] forCellWithReuseIdentifier:kHourCellView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFHourHand" bundle:nil] forCellWithReuseIdentifier:kHourHandCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFMinHand" bundle:nil] forCellWithReuseIdentifier:kMinsHandCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFSecondHand" bundle:nil] forCellWithReuseIdentifier:kSecsHandCell];
    
    self.clockLayout = [[CMFClockLayout alloc] init];
    [self.clockLayout setLayoutCollectionView:self.collectionView];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hhmmss"];
    NSDate *initialTime = [NSDate date];
    [self.clockLayout setTime:initialTime];
    
    [self.clockLayout setHourHandSize:CGSizeMake(10, 300)];
    [self.clockLayout setMinuteHandSize:CGSizeMake(10, 380)];
    [self.clockLayout setSecondHandSize:CGSizeMake(4, 400)];
    
    [self.collectionView setCollectionViewLayout:self.clockLayout];
    
}

-(void)updateClock {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate *currentTime = [NSDate date];
    [self.clockLayout setTime:currentTime];

    [self.collectionView.collectionViewLayout invalidateLayout];
    
    NSString *timeString = [formatter stringFromDate:currentTime];
    NSString *hourString = [timeString substringWithRange:NSMakeRange(0, 2)];
    NSString *minString = [timeString substringWithRange:NSMakeRange(2, 2)];
    NSString *secString = [timeString substringWithRange:NSMakeRange(4, 2)];
    
    [self.timeLabel setText:[NSString stringWithFormat:@"%@:%@:%@", hourString, minString, secString]];
    
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
        
        if (indexPath.row == 0) {
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kHourHandCell forIndexPath:indexPath];
        }
        
        if (indexPath.row == 1) {
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kMinsHandCell forIndexPath:indexPath];
        }
        
        if (indexPath.row == 3) {
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kSecsHandCell forIndexPath:indexPath];
        }

    }
    
    return cell;

}

@end
