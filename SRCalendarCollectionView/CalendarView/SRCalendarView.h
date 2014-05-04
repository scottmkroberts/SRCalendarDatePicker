//
//  SRCalendarView.h
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 01/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SRCalendarView : UIView

//The color all date labels will be
@property (nonatomic, strong) UIColor *dateLabelColor;

//The color of the date label today will be when not selected
@property (nonatomic, strong) UIColor *dateLabelTodayColor;

@property (nonatomic, strong) UIColor *calendarBackgroundColor;

@end
