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


@end

@implementation SRViewController

static NSString *CellIdentifier = @"CalendarCell";




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
    return 21;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SRCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"index path = %@", indexPath);
    
    cell.dayOfMonthLabel.text = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    return CGSizeMake(35.f, 40.f);
}

#pragma mark - 
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // TODO: Select Item
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
