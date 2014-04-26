//
//  ProgressDetailsLikeListViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/9/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "timelinePostLike.h"
#import "TimelinePostCommentTableViewCell.h"
#import "UserProfileViewController.h"
#import "Progress.h"
#import "AMPAvatarView.h"
#import <QuartzCore/QuartzCore.h>

@interface ProgressDetailsLikeListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) Progress *currentProgress;
@property (nonatomic,strong) User *currentUser;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sPosts;

@property (strong, nonatomic) AMPAvatarView *avatar2;


@end
