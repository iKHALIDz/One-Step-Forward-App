//
//  ProgressTableViewCell.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *progressName;

@property (weak, nonatomic) IBOutlet UILabel *progressPercentage;


@property (weak, nonatomic) IBOutlet UILabel *cellStepOrder;

@property (weak, nonatomic) IBOutlet UILabel *ProgressDate;

@property (weak, nonatomic) IBOutlet UIButton *comments;

@property (weak, nonatomic) IBOutlet UILabel *numberOfComments;
@property (weak, nonatomic) IBOutlet UILabel *nLikes;
@property (weak, nonatomic) IBOutlet UIButton *likes;

@end
