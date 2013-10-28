//
//  CMFViewController.m
//  UIClock
//
//  Created by Tim on 10/10/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMFViewController.h"
#import "UIClockConfig.h"
#import "CMFClockLayout.h"
#import "CMFHandsCell.h"

@interface CMFViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *tickTimer;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CMFClockLayout *clockLayout;
@end

@implementation CMFViewController

#pragma mark -
#pragma mark View lifecycle methods

- (void)viewDidLoad {

    [super viewDidLoad];

    // Set up the data, configure the collection view and force
    // it to display the current time
    [self setupData];
    [self configureCollectionView];
    [self updateClock];
    
    // Start the timer to repeatedly update the layout
    self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload {
    [super viewDidUnload];
    [self.tickTimer invalidate];
}

#pragma mark -
#pragma mark View rotation methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:0.1f animations:^{
        [self.collectionView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    }];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [UIView animateWithDuration:0.25f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
}

#pragma mark -
#pragma mark Setup methods

-(void)setupData {
    
    NSMutableArray *hoursArray = [NSMutableArray arrayWithArray:@[@"12", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"]];
    NSArray *handsArray = @[@"hours", @"minutes", @"", @"seconds"];
    
    self.dataArray = [NSMutableArray arrayWithObjects:hoursArray, handsArray, nil];
    
}

-(void)configureCollectionView {

    [self.collectionView registerNib:[UINib nibWithNibName:@"CMFHourLabelView" bundle:nil] forCellWithReuseIdentifier:CMHourCellView];
    [self.collectionView registerClass:[CMFHandsCell class] forCellWithReuseIdentifier:CMHourHandCell];
    [self.collectionView registerClass:[CMFHandsCell class] forCellWithReuseIdentifier:CMMinsHandCell];
    [self.collectionView registerClass:[CMFHandsCell class] forCellWithReuseIdentifier:CMSecsHandCell];
    
    self.clockLayout = [[CMFClockLayout alloc] init];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hhmmss"];
    NSDate *initialTime = [NSDate date];
    [self.clockLayout setTime:initialTime];
    
    [self.clockLayout setHourHandSize:CGSizeMake(54, 150)];
    [self.clockLayout setMinuteHandSize:CGSizeMake(26, 200)];
    [self.clockLayout setSecondHandSize:CGSizeMake(10, 180)];
    
    [self.collectionView setCollectionViewLayout:self.clockLayout];
    
}

-(void)updateClock {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate *currentTime = [NSDate date];
    //NSDate *currentTime = [formatter dateFromString:@"120000"];
    
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
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CMHourCellView forIndexPath:indexPath];
        
        NSArray *hoursLabelsArray = [self.dataArray objectAtIndex:0];
        NSString *hoursText = [hoursLabelsArray objectAtIndex:indexPath.row];
        
        UILabel *hoursLabel = (UILabel *)[cell viewWithTag:1000];
        [hoursLabel setText:hoursText];

    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CMHourHandCell forIndexPath:indexPath];
            UIImageView *hourImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackHour"]];
            [cell.contentView addSubview:hourImageView];
            [cell.layer setAnchorPoint:CGPointMake(0.5f, 0.9f)];
        }
        
        if (indexPath.row == 1) {
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CMMinsHandCell forIndexPath:indexPath];
            UIImageView *minsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackMinute"]];
            [cell.contentView addSubview:minsImageView];
            [cell.layer setAnchorPoint:CGPointMake(0.5f, 0.937f)];
        }
        
        if (indexPath.row == 3) {
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CMSecsHandCell forIndexPath:indexPath];
            UIImageView *minsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackSecond"]];
            [cell.contentView addSubview:minsImageView];
            [cell.layer setAnchorPoint:CGPointMake(0.5f, 0.972f)];
        }

    }
    
    return cell;

}

@end
