//
//  achievedGoalsUIViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/27/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "newGoalViewController.h"
#import "User.h"
#import "Goal.h"

#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

#import "FMDatabase.h"
#import "goalTableViewCell.h"
#import "goalDetailsViewController.h"

@interface achievedGoalsUIViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) User *currentUser;
@property(nonatomic,strong) Goal *currentGoal;
@property(nonatomic,retain) NSMutableArray *achievedGoalsArray;
@property(nonatomic,retain) NSMutableArray *achievedGoalsArrayFromParse;

@property (nonatomic,strong) MDRadialProgressView *radialView;

@property (weak, nonatomic) IBOutlet UITableView *tableviw;


@end
