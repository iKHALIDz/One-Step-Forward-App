//
//  ProgressDetailsLikeListViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/9/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "ProgressDetailsLikeListViewController.h"

@interface ProgressDetailsLikeListViewController ()

@end

@implementation ProgressDetailsLikeListViewController


@synthesize currentProgress,currentUser;
@synthesize sPosts;
@synthesize tableView=_tableView;



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
    sPosts=[[NSMutableArray alloc]init];

    // Do any additional setup after loading the view.
    sPosts=[self getPostsCommments];
    NSLog(@"444:  %d",[sPosts count]);
    NSLog(@"curent %d",currentProgress.progressID);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSMutableArray *) getPostsCommments
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PostLike"];
    
    [query whereKey:@"To" equalTo:self.currentUser.userUsername];
    [query whereKey:@"ItemID" equalTo:[NSString stringWithFormat:@"%d",self.currentProgress.progressID]];
    [query whereKey:@"isLiked" equalTo:@YES];
    
    NSError *error=nil;
    
    NSArray* goals=[query findObjects:&error];
    
    for(PFObject *obj in goals)
    {
        timelinePostLike *postlike=[[timelinePostLike alloc]init];
        
        postlike.To=[obj objectForKey:@"To"];
        postlike.From=[obj objectForKey:@"From"];
        postlike.isLiked=[[obj objectForKey:@"isLiked"] boolValue];
        postlike.PostID=[obj objectForKey:@"PostID"];
        postlike.ItemRID=[obj objectForKey:@"ItemID"];
        PFFile *image = (PFFile *)[obj objectForKey:@"FromuserProfilePic"];
        postlike.FromuserProfilePic=[UIImage imageWithData:[image getData]];
        
        [list addObject:postlike];
    }
    
    return list;
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
    
    cell.FromUserimage.image=[[sPosts objectAtIndex:indexPath.row] FromuserProfilePic];
    
    [cell.GoToUserProfile addTarget:self action:@selector(GoToUserInfo:)  forControlEvents:UIControlEventTouchUpInside];
    [cell.GoToUserProfile setTag:indexPath.row];
    
    return cell;
}

- (IBAction)GoToUserInfo:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    int row = button.tag;
    NSLog(@"isPressed");
    
    NSLog(@"%d",row);
    currentUser.userUsername=[[sPosts objectAtIndex:row] From];
    [self performSegueWithIdentifier:@"GoToUserProfile" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"GoToUserProfile"])
    {
        UserProfileViewController *nav = [segue destinationViewController];
        [nav setSelectedUsername:currentUser.userUsername];
        [nav setCurrentUser:currentUser];
    }
}


@end
