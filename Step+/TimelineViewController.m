//
//  TimelineViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()

@end


@implementation TimelineViewController
@synthesize timelinePosts;
@synthesize selectedtimeLinePost;
@synthesize currentUser;
@synthesize currentUsername;
@synthesize postLikes;
@synthesize postStat;
@synthesize posts;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self getPosts];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    selectedtimeLinePost=[[TimelinePost alloc]init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refreshControl];
    
    postLikes=[[NSMutableArray alloc]init];
    
    postStat=[[NSMutableArray alloc]init];

    
    posts=[[NSMutableArray alloc]init];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStats = [reach currentReachabilityStatus];
    
    if (internetStats == NotReachable) {
        UIAlertView *alertOne = [[UIAlertView alloc] initWithTitle:@"Internet" message:@"is DOWN!!!" delegate:self cancelButtonTitle:@"Damnit!!" otherButtonTitles:@"Cancel", nil];
        [alertOne show];
        [self getPosts];
        [self.tableview reloadData];


    }
    else {
        [self getPosts];
        [self.tableview reloadData];

    }
    
    
    NSLog(@"View Didload %d",[timelinePosts count]);
}

-(NSString *) GetTimeinWords: (NSString *) Y
{
    NSLog(@"rrr");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *dateFromString = [[NSDate alloc]init];
    
    dateFromString = [dateFormatter dateFromString:Y];
    
    NSString * I=[dateFromString prettyDate];
    
    
    return I;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self getPosts];
    
    [self.tableview reloadData];
    
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timelinePosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"timelineCell";
    
    timelineCell *cell = (timelineCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"timelineCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.name.text=[NSString stringWithFormat:@"%@ %@",[[timelinePosts objectAtIndex:indexPath.row] userFirstName],[[timelinePosts objectAtIndex:indexPath.row] userLastName]];
    cell.postContent.text=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:indexPath.row] PostContent]];
    cell.timedate.text=[self GetTimeinWords:[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:indexPath.row] PostDate]]];
    
    
    cell.userpic.image=[[timelinePosts objectAtIndex:indexPath.row] userProfilePic];
    
    [cell.toUserinfo addTarget:self action:@selector(GoToUserInfo:)  forControlEvents:UIControlEventTouchUpInside];
    [cell.toUserinfo setTag:indexPath.row];
    
    [cell.like setTag:indexPath.row];
    
    [cell.like addTarget:self action:@selector(isLikeisPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.goToCommentsButton addTarget:self action:@selector(goToComments:) forControlEvents:UIControlEventTouchUpInside];
    [cell.goToCommentsButton setTag:indexPath.row];
    
    
    for (id obj in [[timelinePosts objectAtIndex:indexPath.row] whoLikePost]) {
        NSLog(@"%@",obj);
        NSLog(@"c%@",currentUser.userUsername);
        
        if ([obj isEqualToString:currentUser.userUsername])
        {
            cell.like.selected=YES;
        }
        else
        {
            cell.like.selected=NO;
        }
        
    }
    
    cell.numberOfLikess.text=[NSString stringWithFormat:@"%d",[[[timelinePosts objectAtIndex:indexPath.row] whoLikePost] count]];
    
    cell.numberOfComments.text=[NSString stringWithFormat:@"%d",[[[timelinePosts objectAtIndex:indexPath.row] whoCommentPost] count]];
    
    
    return cell;
}


- (IBAction)isLikeisPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    int row = button.tag;
    TimelinePost *post=[[TimelinePost alloc]init];
    
    post=[timelinePosts objectAtIndex:row];
    
    if (button.isSelected)
    {
        [button  setImage:[UIImage imageNamed:@"Like1.png"] forState:UIControlStateNormal];
        
        int index = [[post whoLikePost] indexOfObject:currentUser.userUsername];
        
        [[post whoLikePost] removeObjectAtIndex:index];
        
        [post UpdatePostLikes];
        
        timelinePostLike *tLike=[[timelinePostLike alloc]init];
        
        tLike.From=currentUser.userUsername;
        tLike.FromuserProfilePic=currentUser.userProfileImage;
        tLike.PostID=[[timelinePosts objectAtIndex:row]postID];
        tLike.To=[[timelinePosts objectAtIndex:row]username];
        tLike.ItemRID=[[timelinePosts objectAtIndex:row] PostOtherRelatedInFormationContent];
        
        [tLike unlike];
        
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
        
        [query whereKey:@"progressID" equalTo:[NSString stringWithFormat:@"%@",post.PostOtherRelatedInFormationContent]];
        [query whereKey:@"createdBy" equalTo:post.username];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * updateGoals, NSError *error){
            if (!error) {
                
                for (PFObject* obj in updateGoals)
                {
                    NSString *temp=[obj objectForKey:@"numberOfLikes"];
                    NSInteger Nummber=[temp integerValue]-1;
                    NSLog(@"%d",Nummber);
                    
                    [obj setObject:[NSString stringWithFormat:@"%d",Nummber] forKey:@"numberOfLikes"];
                    
                    [obj saveEventually];
                }
            }
        }];
        
        
        
        
    }
    
    else
    {
        
        [button  setImage:[UIImage imageNamed:@"Like2.png"] forState:UIControlStateSelected];
        [[post whoLikePost] addObject:currentUser.userUsername];
        
        [post UpdatePostLikes];
        
        timelinePostLike *tLike=[[timelinePostLike alloc]init];
        
        tLike.From=currentUser.userUsername;
        tLike.FromuserProfilePic=currentUser.userProfileImage;
        tLike.PostID=[[timelinePosts objectAtIndex:row]postID];
        tLike.To=[[timelinePosts objectAtIndex:row]username];
        tLike.ItemRID=[[timelinePosts objectAtIndex:row] PostOtherRelatedInFormationContent];
        
        [tLike like];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
        
        [query whereKey:@"progressID" equalTo:[NSString stringWithFormat:@"%@",post.PostOtherRelatedInFormationContent]];
        [query whereKey:@"createdBy" equalTo:post.username];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * updateGoals, NSError *error){
            if (!error) {
                
                for (PFObject* obj in updateGoals)
                {
                    NSString *temp=[obj objectForKey:@"numberOfLikes"];
                    NSInteger Nummber=[temp integerValue]+1;
                    NSLog(@"%d",Nummber);
                    
                    [obj setObject:[NSString stringWithFormat:@"%d",Nummber] forKey:@"numberOfLikes"];
                    
                    [obj saveEventually];
                }
            }
        }];
        
    }
    
    [button  setSelected:!button.isSelected];
    
    [self.tableview reloadData];
    
}

- (IBAction)GoToUserInfo:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    int row = button.tag;
    NSLog(@"isPressed");
    
    
    currentUsername=[[timelinePosts objectAtIndex:row] username];
    
    
    [self performSegueWithIdentifier:@"GoToUserProfile" sender:self];
}

- (IBAction)goToComments:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    int row = button.tag;
    NSLog(@"isPressed");
    
    
    selectedtimeLinePost.userFirstName=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:row] userFirstName]];
    
    selectedtimeLinePost.userLastName=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:row] userLastName]];
    
    selectedtimeLinePost.username=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:row] username]];
    
    selectedtimeLinePost.userProfilePic=[[timelinePosts objectAtIndex:row] userProfilePic];
    
    selectedtimeLinePost.PostDate=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:row] PostDate]];
    
    selectedtimeLinePost.PostContent=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:row] PostContent]];
    
    selectedtimeLinePost.postID=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:row] postID]];
    
    selectedtimeLinePost.PostOtherRelatedInFormationContent=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:row] PostOtherRelatedInFormationContent]];
    
    
    selectedtimeLinePost.whoCommentPost=[[timelinePosts objectAtIndex:row] whoCommentPost];
    
    
    selectedtimeLinePost.whoLikePost=[[timelinePosts objectAtIndex:row] whoLikePost];
    
    
    [self performSegueWithIdentifier:@"TimelinePostToDetails" sender:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(void) getPosts
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Timeline"];
    [query orderByDescending:@"PostDate"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(findCallback:error:)];
}


- (void)findCallback:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        
        self.timelinePosts=[[NSMutableArray alloc]init];
        
        for(PFObject *obj in objects)
        {
            NSLog(@"tttt");
            TimelinePost *post=[[TimelinePost alloc]init];
            post.userFirstName=[obj objectForKey:@"userFirstName"];
            post.userLastName=[obj objectForKey:@"userLastName"];
            post.username=[obj objectForKey:@"username"];
            post.PostDate=[obj objectForKey:@"PostDate"];
            post.PostContent=[obj objectForKey:@"PostContent"];
            post.postID=[obj objectForKey:@"postID"];
            post.PostOtherRelatedInFormationContent=[obj objectForKey:@"PostOtherRelatedInFormationContent"];
            post.whoLikePost=[obj objectForKey:@"whoLikePost"];
            post.whoCommentPost=[obj objectForKey:@"whoCommentPost"];
            
            PFFile *image = (PFFile *)[obj objectForKey:@"userProfilePic"];
            post.userProfilePic=[UIImage imageWithData:[image getData]];
            
            
            [timelinePosts addObject:post];
            
        }
        [self.tableview reloadData];

    } else
    {
        
        
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TimelinePostToDetails"])
    {
        TimelinePostDetailsViewController *nav = [segue destinationViewController];
        [nav setCurrentSelectedtimeLinePost:selectedtimeLinePost];
        [nav setCurrentUser:currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"GoToUserProfile"])
    {
        UserProfileViewController *nav = [segue destinationViewController];
        [nav setSelectedUsername:self.currentUsername];
        [nav setCurrentUser:currentUser];
    }
}

@end
