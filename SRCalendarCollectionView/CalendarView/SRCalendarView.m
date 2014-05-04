//
//  SRCalendarView.m
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 01/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import "SRCalendarView.h"
#import "SRCalendarCollectionViewLayout.h"
#import "SRCalendarCollectionViewCell.h"

@interface SRCalendarView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SRCalendarCollectionViewLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *daysOfTheWeek;

@property (nonatomic, assign) CGFloat lastContentOffset;

@property (nonatomic, strong) NSNumber *currentWeekNumber, *currentWeekDay, *currentYear;
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) UILabel *dateDescription;

@property (nonatomic, strong) UIView *header, *footer;

@property (nonatomic, strong) NSDate *lastSelectedDate;

//Stores the 3 weeks
@property (nonatomic, strong) NSArray *previousWeek ,*currentWeek, *nextWeek;

@property (nonatomic) NSUInteger weekdayNumber;
@end

@implementation SRCalendarView

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


-(BOOL)isTheDatesTheSame:(NSDate *)date1 andDate2:(NSDate *)date2{
    return ([date1 compare:date2] == NSOrderedSame);
}

-(NSString *)dayFromDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE"];
    return [format stringFromDate:date];
}

-(NSString *)dateOnlyFromDate:(NSDate *)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

#pragma mark -
#pragma mark - Helpers

-(void)updateDateDescriptionLabelWithDate:(NSDate *)date{
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"EEEE dd MMMM yyyy"];
  
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.dateDescription.alpha = 0.0f;

                         self.dateDescription.text = [NSString stringWithFormat:@"%@", [inFormat stringFromDate:date]];
                         self.lastSelectedDate =  [inFormat dateFromString:self.dateDescription.text];
                         self.weekdayNumber = [self.calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];

                         self.dateDescription.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         

                     }];
    
}

-(void)createDataSet{
    NSMutableArray *oneArray = [NSMutableArray array];
    [oneArray addObjectsFromArray:self.previousWeek];
    [oneArray addObjectsFromArray:self.currentWeek];
    [oneArray addObjectsFromArray:self.nextWeek];
    self.daysOfTheWeek = [oneArray copy];
    
    NSLog(@"days of the week data = %@", self.daysOfTheWeek);
    
}

-(void)selectDefaultCell{
    
    //[self collectionView:yourView didSelectItemAtIndexPath:yourIndexPath]
}

#pragma mark -
#pragma mark Data

-(void)updateDateAfterShiftWithDay:(int)day{
    NSDateComponents *oneWeek = [[NSDateComponents alloc] init];
    [oneWeek setDay:day];
    self.lastSelectedDate = [self.calendar dateByAddingComponents:oneWeek toDate:self.lastSelectedDate options:0];
    [self updateDateDescriptionLabelWithDate:self.lastSelectedDate];
    
}

-(void)shiftCalendarLeft{
    self.currentWeekNumber = [NSNumber numberWithInteger:[self.currentWeekNumber intValue] - 1];
    [self updateDateAfterShiftWithDay:-7];
    [self buildCalendarData];
}

-(void)shiftCalendarRight{
    
    self.currentWeekNumber = [NSNumber numberWithInteger:[self.currentWeekNumber intValue] + 1];
    [self updateDateAfterShiftWithDay:+7];
    [self buildCalendarData];
}


-(void)buildCalendarData{
    
    self.previousWeek= [self getDatesForWeek:[self.currentWeekNumber intValue] - 1 inYear:[self.currentYear intValue]];
    self.currentWeek = [self getDatesForWeek:[self.currentWeekNumber intValue] inYear:[self.currentYear intValue]];
    self.nextWeek = [self getDatesForWeek:[self.currentWeekNumber intValue] + 1 inYear:[self.currentYear intValue]];

    [self createDataSet];
    
    [self.collectionView reloadData];

    
     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];


    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:8 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    

    
}

#pragma mark -
#pragma mark - Setters

-(void)setCalendarBackgroundColor:(UIColor *)calendarBackgroundColor{
    _calendarBackgroundColor = calendarBackgroundColor;
    self.backgroundColor = self.calendarBackgroundColor;
}

#pragma mark - 
#pragma mark Steup

-(void)defaults{
    
    self.dateLabelColor = [UIColor blackColor];
    self.dateLabelTodayColor = [UIColor redColor];
    self.calendarBackgroundColor = [UIColor whiteColor];
}

-(void)addHeader{
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40.0f)];
    //self.header.backgroundColor = [UIColor redColor];
    
    CGFloat width = CGRectGetWidth(self.frame) / 7;
    NSArray *lettersOfTheDayOfTheWeek = @[@"M",@"T", @"W", @"T", @"F", @"S", @"S"];
    
    for (int i = 0; i < lettersOfTheDayOfTheWeek.count ; i++) {
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * i, 0, width, CGRectGetHeight(self.header.frame))];
        dayLabel.text = [lettersOfTheDayOfTheWeek objectAtIndex:i];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.font = [UIFont systemFontOfSize:12.0];
        [self.header addSubview:dayLabel];
    }

    [self addSubview:self.header];
    
}

-(void)addFooter{
    
    self.footer = [[UIView alloc] initWithFrame:CGRectMake(0, 80.0f, CGRectGetWidth(self.frame), 40.0f)];
    //self.footer.backgroundColor = [UIColor yellowColor];
    
    self.dateDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.footer.frame), CGRectGetHeight(self.footer.frame))];
    self.dateDescription.textAlignment = NSTextAlignmentCenter;
    self.dateDescription.text = @"Monday, 1, jab";
    
    [self.footer addSubview:self.dateDescription];
    
    [self addSubview:self.footer];

}

-(void)addCollectionView{
    self.collectionViewLayout = [[SRCalendarCollectionViewLayout alloc] init];
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40.0, CGRectGetWidth(self.frame), 40.0f) collectionViewLayout:self.collectionViewLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[SRCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"CalendarCell"];
    [self.collectionView registerClass:[SRCalendarCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    self.collectionView.pagingEnabled = YES;
    
    
    [self addSubview:self.collectionView];
}

-(void)setupData{
    
    [self.collectionViewLayout invalidateLayout];

    NSDate *today = [NSDate date];
    [self updateDateDescriptionLabelWithDate:today];
    
    self.calendar = [NSCalendar currentCalendar];
    [self.calendar setFirstWeekday:2]; //First day of the week set to Monday
    [self.calendar setLocale:[NSLocale currentLocale]];
    
    NSInteger weekdayNumber;
    
    //Todays date
    NSDateComponents *todayComponents = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSWeekOfYearCalendarUnit|NSYearForWeekOfYearCalendarUnit fromDate:today];
    weekdayNumber = [self.calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:today];
    
    self.currentWeekNumber = [NSNumber numberWithInteger:[todayComponents weekOfYear]];
    self.currentWeekDay = [NSNumber numberWithInteger:weekdayNumber];
    NSLog(@"current year = %ld", (long)[todayComponents yearForWeekOfYear]);
    
    self.currentYear =[NSNumber numberWithInteger:[todayComponents yearForWeekOfYear]];
    
    self.previousWeek= [self getDatesForWeek:[self.currentWeekNumber intValue] - 1 inYear:[todayComponents year]];
    self.currentWeek = [self getDatesForWeek:[self.currentWeekNumber intValue] inYear:[todayComponents year]];
    self.nextWeek = [self getDatesForWeek:[self.currentWeekNumber intValue] + 1 inYear:[todayComponents year]];
    
    [self createDataSet];
    
  
    
    [self.collectionView reloadData];
    
    
    //NSLog(@"current week = %@", currentWeek);
    
}

#pragma mark -
#pragma mark init


-(id)init{
    
    self  = [super init];
    if(self){
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.frame = CGRectMake(0, 20, 320.0f, 120);
        self.backgroundColor = self.calendarBackgroundColor;
        
        [self addHeader];
        [self addFooter];
        [self addCollectionView];
        [self setupData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:10 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

        [self defaults];
    
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


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

    NSDate *date = [self.daysOfTheWeek objectAtIndex:indexPath.row];
    

    //Date comparisons
    NSString *indexRowDate = [self dayFromDate:date];
    NSString *lastSelectedRowDate = [self dayFromDate:self.lastSelectedDate];
    
    NSString *today = [self dateOnlyFromDate:[NSDate date]];
    NSString *lastSelectedRowDate2 = [self dateOnlyFromDate:self.lastSelectedDate];
    NSString *indexRowDate2 = [self dateOnlyFromDate:date];

    NSLog(@"date1 = %@ |  date2 = %@", indexRowDate, lastSelectedRowDate);
    
    //Check if it is today and not selected
    if([today isEqualToString:indexRowDate2] && !cell.selected){
        cell.dayOfMonthLabel.textColor = self.dateLabelTodayColor; //Color 1
    }else{
        cell.dayOfMonthLabel.textColor = self.dateLabelColor; //Color 2
    }

    
    //Hightlight selected date
    if([indexRowDate2 isEqualToString:lastSelectedRowDate2]){
        cell.selected = YES;
    }
    
    
//
//    if([indexRowDate isEqualToString:lastSelectedRowDate]){
//        
//        //is it today?
//        if([today isEqualToString:lastSelectedRowDate2]){
//            
//            cell.selectedBGView.backgroundColor = [UIColor redColor];
//        }else{
//            cell.selectedBGView.backgroundColor = [UIColor blackColor];
//        }
//
//        cell.selected = YES;
//    }else{
//        cell.selected = NO;
//    }
    
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
    NSLog(@"Did select date = %@", date);

    [self updateDateDescriptionLabelWithDate:date];
    [self.collectionView reloadData]; //hmmmmm
    
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
        NSLog(@"Moved Right");
        [self shiftCalendarRight];
    }
    else if (_lastContentOffset > (int)scrollView.contentOffset.x) {
        NSLog(@"Moved Left");
        [self shiftCalendarLeft];
        
    }
}


@end
