//
//  timelineCell.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "timelineCell.h"

@implementation timelineCell


@synthesize lastTwoComments;
@synthesize tableview=_tableview;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//        self.frame = CGRectMake(0, 0, 200, 50);
//        UITableView *subMenuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain]; //create tableview a
//        
//        subMenuTableView.tag = 100;
//        subMenuTableView.delegate = self;
//        subMenuTableView.dataSource = self;
//        
//        
//        NSLog(@"outside");
//        
//        [self addSubview:subMenuTableView]; // add it cell
//    }
//    return self;
//}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)comment:(UIButton *)sender {
    
}
- (IBAction)LikeAction:(UIButton *)sender {
    
    
}


//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    UITableView *subMenuTableView =(UITableView *) [self viewWithTag:100];
//    subMenuTableView.frame = CGRectMake(0.2, 0.3, self.bounds.size.width-5, self.bounds.size.height-5);//set the frames for tableview
//
//    self.tableview.separatorColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
//    NSLog(@"outside");
//    
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lastTwoComments.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TimelinePostCommentTableViewCell";
    
    TimelinePostCommentTableViewCell *cell = (TimelinePostCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelinePostCommentTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.FromUserComment.text=[NSString stringWithFormat:@"%@",[[lastTwoComments objectAtIndex:indexPath.row] commentContent]];
    
//    cell.FromUserimage.image=[[lastTwoComments objectAtIndex:indexPath.row] FromuserProfilePic];


    
                               NSLog(@"Inside");
    
    
    cell.backgroundColor=[UIColor colorWithHexString:@"fffcfc"];
    
    
    return cell;
    
}

@end
