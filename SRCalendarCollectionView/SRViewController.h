//
//  SRViewController.h
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 24/04/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface SRViewController : UIViewController

@end
