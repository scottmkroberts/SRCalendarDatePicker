//
//  SRViewController.m
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 24/04/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import "SRViewController.h"
#import "SRCalendarCollectionViewLayout.h"
#import "SRCalendarCollectionViewCell.h"

@interface SRViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SRCalendarCollectionViewLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *daysOfTheWeek;

@property (nonatomic, assign) CGFloat lastContentOffset;

@property (nonatomic, strong) NSNumber *currentWeek, *currentWeekDay;
@property (nonatomic, strong)  NSCalendar *calendar;

@property (nonatomic, strong) IBOutlet UILabel *dateDescription;

@end

@implementation SRViewController

static NSString *CellIdentifier = @"CalendarCell";

#pragma mark - Date stuff

-(NSDate *)getDayOfWeek:(NSInteger)weekDay inWeekNumber:(NSInteger)weekNumber inYear:(NSInteger)year{
    
    NSDateComponents *dayComponents = [[NSDateComponents alloc] init];
    [dayComponents setWeekday:weekDay];
    [dayComponents setWeekOfYear:weekNumber];
    [dayComponents setYear:year];
    [dayComponents setYearForWeekOfYear:year];
    
    return [self.calendar dateFromComponents:dayComponents];
}

-(NSArray *)getDatesForWeek:(NSInteger)weekNumber inYear:(NSInteger)year{
    
    NSMutableArray *dates = [[NSMutableArray alloc] initWithCapacity:7];
    for (int i = 1; i <=7; i++) {
        NSDate *day = [self getDayOfWeek:i inWeekNumber:weekNumber inYear:year];
        [dates addObject:day];
    }
    
    //Move Sunday to the End
    NSDate *sunday = [dates objectAtIndex:0];
    [dates removeObjectAtIndex:0];
    [dates addObject:sunday];
    
    return [dates copy];
}

#pragma mark - 
#pragma mark - Helpers

-(void)updateDateDescriptionLabelWithDate:(NSDate *)date{
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"EEEE dd MMMM yyyy"];
    self.dateDescription.text = [NSString stringWithFormat:@"%@", [inFormat stringFromDate:date]];
}

#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.collectionViewLayout = [[SRCalendarCollectionViewLayout alloc] init];
    [self.collectionView setCollectionViewLayout:self.collectionViewLayout];

    [self.collectionView registerClass:[SRCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"CalendarCell"];
    
    [self.collectionView registerClass:[SRCalendarCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    self.collectionView.pagingEnabled = YES;
    
    self.daysOfTheWeek = @[@"M", @"T", @"W", @"T", @"F", @"S", @"S"];
    
    NSDate *today = [NSDate date];
    
    self.calendar = [NSCalendar currentCalendar];
    [self.calendar setFirstWeekday:2]; //First day of the week set to Monday
    [self.calendar setLocale:[NSLocale currentLocale]];
    
    NSInteger weekdayNumber;
    
    //Todays date
    NSDateComponents *todayComponents = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSWeekOfYearCalendarUnit fromDate:today];
    weekdayNumber = [self.calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:today];
    
    self.currentWeek = [NSNumber numberWithInteger:[todayComponents weekOfYear]];
    self.currentWeekDay = [NSNumber numberWithInteger:weekdayNumber];

    
    NSArray *previousWeek = [self getDatesForWeek:[self.currentWeek intValue] - 1 inYear:[todayComponents year]];
    NSArray *currentWeek = [self getDatesForWeek:[self.currentWeek intValue] inYear:[todayComponents year]];
    NSArray *nextWeek = [self getDatesForWeek:[self.currentWeek intValue] + 1 inYear:[todayComponents year]];

    NSMutableArray *oneArray = [NSMutableArray array];
    [oneArray addObjectsFromArray:previousWeek];
    [oneArray addObjectsFromArray:currentWeek];
    [oneArray addObjectsFromArray:nextWeek];
    self.daysOfTheWeek = [oneArray copy];
    
    for (NSDate *date in currentWeek) {
        
        NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
        [inFormat setDateFormat:@"EEEE dd MMMM yyyy"];
        NSLog(@"date = %@", [inFormat stringFromDate:date]);
    }

    //NSLog(@"current week = %@", currentWeek);
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Start position
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:10 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.collectionViewLayout invalidateLayout];
    //[self.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.daysOfTheWeek.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SRCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"index path = %@", indexPath);
    
    NSDate *date = [self.daysOfTheWeek objectAtIndex:indexPath.row];
    NSDateComponents *todayComponents = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSWeekOfYearCalendarUnit fromDate:date];
    cell.dayOfMonthLabel.text = [NSString stringWithFormat:@"%ld", (long)[todayComponents day]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    return CGSizeMake(35.f, 40.f);
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

#pragma mark - 
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // TODO: Select Item
    NSDate *date = [self.daysOfTheWeek objectAtIndex:indexPath.row];
    [self updateDateDescriptionLabelWithDate:date];
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark - 
#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (_lastContentOffset < (int)scrollView.contentOffset.x) {
        // moved right
        NSLog(@"Moved Right");
    }
    else if (_lastContentOffset > (int)scrollView.contentOffset.x) {
        // moved left
        NSLog(@"Moved Left");
        
    }
}




@end
