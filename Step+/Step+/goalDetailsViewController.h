//
//  goalDetailsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/24/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "newProgressViewController.h"
#import "FMDatabase.h"
#import "ProgressTableViewCell.h"
#import "NSDate+PrettyDate.h"



@interface goalDetailsViewController : UIViewController <updateGoal,UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *GoalNameLable;

@property (weak, nonatomic) IBOutlet UILabel *GoalDescriptionLable;

@property (weak, nonatomic) IBOutlet UILabel *TotalPercentageLable;

@property (weak, nonatomic) IBOutlet UILabel *GoalTypeLable;

@property (weak, nonatomic) IBOutlet UILabel *NumberofStepsTakenLable;

@property (weak, nonatomic) IBOutlet UILabel *NumberofdaysyillDeadline;

@property(nonatomic,retain) NSMutableArray *progressList;
@property(nonatomic,retain) NSMutableArray *progressListFromParse;


@property(nonatomic,strong) Goal *currentGoal;
@property (weak, nonatomic) IBOutlet UILabel *numberofDaysSinceCreated;

- (IBAction)deleteGoal:(UIBarButtonItem *)sender;

@end
