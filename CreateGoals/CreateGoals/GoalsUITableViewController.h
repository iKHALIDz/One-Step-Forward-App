//
//  GoalsUITableViewController.h
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goalTableViewCell.h"


@interface GoalsUITableViewController : UITableViewController


@property (nonatomic,strong) NSMutableArray *goalsName;
@property (nonatomic,strong) NSMutableArray *goalsdescription;
@property (nonatomic,strong) NSMutableArray *goalDeadline;

@property (nonatomic,retain) NSString *newg_goaldeadline;
@property (nonatomic,retain) NSString *newg_goalsdescription;
@property (nonatomic,retain) NSString *newg_goalname;


@end
