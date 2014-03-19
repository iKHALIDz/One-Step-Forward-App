//
//  MainMenuViewController.h
//  TestingLogin
//
//  Created by KHALID ALAHMARI on 1/29/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "goalTableViewCell.h"
#import "detailsViewController.h"
#import "CalenderLogsEventsViewController.h"

#import "FMDatabase.h"
#import "Goal.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"



@interface MainMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSString *currentGoal;
@property double currentGoalProgressPercentage;

@property(nonatomic,strong) NSString *currentUserID;
@property(nonatomic,retain) NSMutableArray *array;
@property(nonatomic,retain) NSMutableArray *array2;

@property (nonatomic,strong) MDRadialProgressView *radialView;

@property (nonatomic,strong) Goal *cGoal;


@end