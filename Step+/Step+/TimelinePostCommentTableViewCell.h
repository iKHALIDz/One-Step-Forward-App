//
//  TimelinePostCommentTableViewCell.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelinePostCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *FromUserComment;
@property (weak, nonatomic) IBOutlet UIButton *GoToUserProfile;

@property (weak, nonatomic) IBOutlet UIView *FromUserImageView;

@end
