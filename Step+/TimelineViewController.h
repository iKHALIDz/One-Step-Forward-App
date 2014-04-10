//
//  TimelineViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "timelineCell.h"
#import "TimelinePost.h"
#import "TimelinePostDetailsViewController.h"
#import "User.h"
#import "UserProfileViewController.h"
#import "timelinePostLike.h"
#import "Progress.h"
#import "NSDate+PrettyDate.h"


@interface TimelineViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,retain) NSMutableArray *timelinePosts;
@property (nonatomic,retain) TimelinePost *selectedtimeLinePost;
@property (nonatomic,strong) User *currentUser;

@property (nonatomic,retain) NSString *currentUsername;

@property (nonatomic,retain) NSMutableArray *postLikes;
@property (nonatomic,retain) NSMutableArray *postStat;

@end
