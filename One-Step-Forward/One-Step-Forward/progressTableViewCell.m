//
//  progressTableViewCell.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/26/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "progressTableViewCell.h"

@implementation progressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)delete:(id)sender {
}
@end
