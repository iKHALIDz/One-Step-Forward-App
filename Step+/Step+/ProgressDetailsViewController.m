//
//  ProgressDetailsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "ProgressDetailsViewController.h"

@interface ProgressDetailsViewController ()
@end

@implementation ProgressDetailsViewController


@synthesize currentProgress,currentUser;
@synthesize sPosts;
@synthesize tableview=_tableview;
@synthesize avatar2;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self getPostsCommments];
    
   // NSLog(@"RRR%d",currentProgress.progressID);
   // NSLog(@"RRR%d",[sPosts count]);
    
    
    self.tableview.separatorColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.view.backgroundColor=[UIColor colorWithHexString:@"fffcfc"];

    self.tableview.backgroundColor=[UIColor colorWithHexString:@"fffcfc"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getPostsCommments
{
    PFQuery *query = [PFQuery queryWithClassName:@"PostComment"];
    
    [query whereKey:@"To" equalTo:self.currentUser.userUsername];
    [query whereKey:@"ItemID" equalTo:[NSString stringWithFormat:@"%d",self.currentProgress.progressID]];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(findCallback:error:)];
}


- (void)findCallback:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        sPosts=[[NSMutableArray alloc]init];

        
    for(PFObject *obj in objects)
    {
        
        timelinePostComment *postcomment=[[timelinePostComment alloc]init];
        
        postcomment.To=[obj objectForKey:@"To"];
        postcomment.From=[obj objectForKey:@"From"];
        postcomment.commentContent=[obj objectForKey:@"commentContent"];
        postcomment.PostID=[obj objectForKey:@"PostID"];
        postcomment.ItemID=[obj objectForKey:@"ItemID"];
        PFFile *image = (PFFile *)[obj objectForKey:@"FromuserProfilePic"];
        postcomment.FromuserProfilePic=[UIImage imageWithData:[image getData]];
        
        [sPosts addObject:postcomment];
    }
        [self.tableview reloadData];
}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sPosts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"TimelinePostCommentTableViewCell";
    
    TimelinePostCommentTableViewCell *cell = (TimelinePostCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelinePostCommentTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.FromUserComment.text=[NSString stringWithFormat:@"%@",[[sPosts objectAtIndex:indexPath.row] commentContent]];
    
    avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    avatar2.image=[[sPosts objectAtIndex:indexPath.row] FromuserProfilePic];
    
    [cell.FromUserImageView addSubview:avatar2];
    
    [cell.GoToUserProfile addTarget:self action:@selector(GoToUserInfo:)  forControlEvents:UIControlEventTouchUpInside];
    [cell.GoToUserProfile setTag:indexPath.row];
    
    cell.backgroundColor=[UIColor colorWithHexString:@"fffcfc"];

    
    return cell;
}

- (IBAction)GoToUserInfo:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    int row = button.tag;
    //NSLog(@"isPressed");
    
    //NSLog(@"%d",row);
    currentUser.userUsername=[[sPosts objectAtIndex:row] From];
    [self performSegueWithIdentifier:@"GoToUserProfile" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"GoToUserProfile"])
    {
        UINavigationController *nav = [segue destinationViewController];
        UserProfileViewController*vc = (UserProfileViewController*)nav.topViewController;
        [vc setCurrentUser:currentUser];
        [vc setSelectedUsername:currentUser.userUsername];

    }
}

@end
