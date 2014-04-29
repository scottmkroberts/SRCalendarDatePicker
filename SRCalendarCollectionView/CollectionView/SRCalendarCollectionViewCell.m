//
//  SRCalendarCollectionViewCell.m
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 24/04/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import "SRCalendarCollectionViewCell.h"

@implementation SRCalendarCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    //Day of Month
    self.dayOfMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, CGRectGetWidth(self.contentView.frame), 15)];
    self.dayOfMonthLabel.textColor = [UIColor blackColor];
    self.dayOfMonthLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    [self.contentView addSubview:self.dayOfMonthLabel];
    
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//  
//    
//    
//}


@end
