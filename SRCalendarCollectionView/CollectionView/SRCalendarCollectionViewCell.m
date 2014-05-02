//
//  SRCalendarCollectionViewCell.m
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 24/04/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import "SRCalendarCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface SRCalendarCollectionViewCell ()

@property (nonatomic, strong) UIView *circleBackgroundView;

@end

@implementation SRCalendarCollectionViewCell

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //self.backgroundColor = [UIColor redColor];
            
        //Day of Month
        self.dayOfMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        self.dayOfMonthLabel.textColor = [UIColor blackColor];
        self.dayOfMonthLabel.highlightedTextColor = [UIColor whiteColor];
        self.dayOfMonthLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
        self.dayOfMonthLabel.textAlignment = NSTextAlignmentCenter;
            
        [self.contentView addSubview:self.dayOfMonthLabel];

        UIView* backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        //backgroundView.backgroundColor = [UIColor c];
        self.backgroundView = backgroundView;
        
        self.selectedBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35.0, 35.0)];
        self.selectedBGView.layer.cornerRadius = self.selectedBGView.bounds.size.width/2;
        self.selectedBGView.layer.masksToBounds = YES;
        self.selectedBGView.backgroundColor = [UIColor redColor];
           // [self setRoundedView:selectedBGView toDiameter:40.0];
        self.selectedBackgroundView = self.selectedBGView;
        
        
            
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
