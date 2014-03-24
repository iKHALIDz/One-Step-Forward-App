//
//  achievedGoalsUIViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/19/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "goalTableViewCell.h"
#import "detailsViewController.h"
#import "Goal.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"


@interface achievedGoalsUIViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *achievedGoalsArray;
@property (nonatomic,strong) MDRadialProgressView *radialView;
@property (nonatomic,strong) Goal *currentGoal;


@end
