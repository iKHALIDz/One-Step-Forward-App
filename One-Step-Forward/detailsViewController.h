//
//  detailsViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "progressTableViewCell.h"
#import "AddProgressViewController.h"
#import "MangeProgressViewController.h"
#import "FMDatabase.h"
#import "Goal.h"


@interface detailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,updateGoalPercentage,updateGoalPercentage2>

- (IBAction) declareAchieved:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *numberOfSteps;

@property (weak, nonatomic) IBOutlet UILabel *CurrentGoalProgressLabel;
//@property (nonatomic,retain) NSString *currentGoalID;
//@property double currentGoalProgressPercentage;
@property (nonatomic, strong) NSArray *postArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *doneProgress;
@property(nonatomic,retain) NSMutableArray *array;
@property (nonatomic,strong) Progress *currentProgress;
@property (nonatomic,strong) Goal *currentGoal;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDaysSinceCreated;

@property (weak, nonatomic) IBOutlet UILabel *numberOfDaystillDeadline;

@end
