//
//  goalTableViewCell.h
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goalName;
@property (weak, nonatomic) IBOutlet UILabel *goalDescription;

@property (weak, nonatomic) IBOutlet UILabel *goalDeadline;

@property (weak, nonatomic) IBOutlet UILabel *goalPercentage;



@end
