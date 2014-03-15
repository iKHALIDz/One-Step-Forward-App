//
//  CalenderLogsEventsViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "FMDatabase.h"
#import "Goal.h"



@interface CalenderLogsEventsViewController : UIViewController <CKCalendarDelegate>


@property(nonatomic, strong) CKCalendarView *calendar;
@property (weak, nonatomic) IBOutlet UIView *CalenderView;
@property(nonatomic, strong) NSString *selctedDate;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;


-(NSMutableArray *) getGoalsList:(NSString*)Data;

@end
