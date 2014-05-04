//
//  SRExampleViewController.m
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 01/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import "SRExampleViewController.h"
#import "SRCalendarView.h"

@interface SRExampleViewController ()

@end

@implementation SRExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SRCalendarView *calView = [[SRCalendarView alloc] init];
    //calView.calendarBackgroundColor = [UIColor redColor];
    
    [self.view addSubview:calView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
