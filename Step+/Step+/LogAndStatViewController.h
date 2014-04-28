//
//  LogAndStatViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "Log.h"
#import "RDVCalendarView.h"
#import "logCell.h"
#import "User.h"
#import "Goal.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"


@interface LogAndStatViewController : UIViewController <RDVCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (nonatomic, strong) RDVCalendarView *calendarView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) User *currentUser;

@property(nonatomic,retain) NSMutableArray *inProgressArray;
@property(nonatomic,retain) NSMutableArray *achievedArray;
@property (nonatomic,retain) NSMutableArray *createdGoals;

@property (weak, nonatomic) IBOutlet UIView *createdGoalView;

@property (weak, nonatomic) IBOutlet UIView *InProgressView;

@property (weak, nonatomic) IBOutlet UIView *DoneGoalView;


@property (nonatomic,strong) MDRadialProgressView *radialView;
@property (nonatomic,strong) MDRadialProgressView *radialView2;
@property (nonatomic,strong) MDRadialProgressView *radialView3;

@end
