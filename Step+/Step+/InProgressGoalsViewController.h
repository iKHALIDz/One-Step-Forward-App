//
//  InProgressGoalsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/23/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNBlurModalView.h"
#import <QuartzCore/QuartzCore.h>
#import "newGoalViewController.h"
#import "User.h"
#import "Goal.h"

#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

#import "FMDatabase.h"
#import "goalTableViewCell.h"


@interface InProgressGoalsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) User *currentUser;
@property(nonatomic,strong) Goal *currentGoal;
@property(nonatomic,retain) NSMutableArray *inProgressArray;
@property(nonatomic,retain) NSMutableArray *inProgressArrayFromParse;

@property (nonatomic,strong) MDRadialProgressView *radialView;


@end
