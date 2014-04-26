//
//  goalDetailsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/24/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "User.h"
#import "Progress.h"

#import "newProgressViewController.h"
#import "FMDatabase.h"
#import "ProgressTableViewCell.h"
#import "NSDate+PrettyDate.h"
#import "TimelinePost.h"
#import "goalSuggestionsViewController.h"
#import "ProgressDetailsViewController.h"
#import "ProgressDetailsLikeListViewController.h"
#import "EditGoalViewController.h"
#import "Log.h"
#import <Social/Social.h>

#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"



@interface goalDetailsViewController : UIViewController <updateGoal,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UIView *progressCircle;


@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mangeGoal;

- (IBAction)GoalMange:(UIBarButtonItem *)sender;

@property (strong,nonatomic) Progress * currentProgress;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *GoalNameLable;

@property (weak, nonatomic) IBOutlet UILabel *GoalDescriptionLable;


@property (weak, nonatomic) IBOutlet UILabel *GoalTypeLable;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *NumberofStepsTakenLable;

@property (weak, nonatomic) IBOutlet UILabel *NumberofdaysyillDeadline;

@property(nonatomic,retain) NSMutableArray *progressList;
@property(nonatomic,retain) NSMutableArray *progressListFromParse;

@property(nonatomic,strong) Goal *currentGoal;
@property (nonatomic,strong) User *currentUser;



@property (nonatomic,weak) UIActionSheet *actionSheet;

@property (nonatomic,weak) UIActionSheet *actionSheetMangeGoal;


@property (nonatomic,strong) MDRadialProgressView *radialView;

@property (nonatomic,strong) MDRadialProgressView *radialView2;



@property (weak, nonatomic) IBOutlet UIView *currentPercView;

@end
