//
//  UserProfileViewControllerDetailsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "timelineCell.h"
#import "TimelinePost.h"
#import <Parse/Parse.h>
#import "User.h"

@interface UserProfileViewControllerDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *gPosts;
@property (nonatomic,strong) Goal* cgoal;

@property (weak, nonatomic) IBOutlet UITextField *suggestionTextField;
- (IBAction)send:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) User *currentUser;

@end
