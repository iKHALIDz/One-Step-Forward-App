//
//  timelineCell.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelinePostCommentTableViewCell.h"
#import "UIColor+ConvertHexToUIColor.h"

#import "timelinePostComment.h"

@interface timelineCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *timedate;

@property (weak, nonatomic) IBOutlet UIImageView *userpic;


@property (weak, nonatomic) IBOutlet UILabel *postContent;

- (IBAction)comment:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *toUserinfo;

@property (weak, nonatomic) IBOutlet UIButton *like;

- (IBAction)LikeAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *numberOfLikess;

@property (weak, nonatomic) IBOutlet UILabel *numberOfComments;

@property (weak, nonatomic) IBOutlet UIButton *goToCommentsButton;

@property (weak, nonatomic) IBOutlet UIView *profileView;

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property (strong,nonatomic) NSMutableArray *lastTwoComments;

@end
