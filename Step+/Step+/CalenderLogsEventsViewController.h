//
//  CalenderLogsEventsViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "Log.h"
#import "RDVCalendarView.h"
#import "logCell.h"
#import "User.h"


@interface CalenderLogsEventsViewController : UIViewController <RDVCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) RDVCalendarView *calendarView;
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@property (weak, nonatomic) IBOutlet UITableView *calenderLog;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) User *currentUser;


@end
