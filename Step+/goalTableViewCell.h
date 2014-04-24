//
//  goalTableViewCell.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/23/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *GoalName;
@property (weak, nonatomic) IBOutlet UILabel *DueDate;


@property (weak, nonatomic) IBOutlet UIButton *MoveCell;

@end
