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
    self.timelinePosts=[[NSMutableArray alloc]init];
    selectedtimeLinePost=[[TimelinePost alloc]init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refreshControl];
    self.timelinePosts=[self getPosts];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    self.timelinePosts=[self getPosts];
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
    cell.timedate.text=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:indexPath.row] PostDate]];

    cell.userpic.image=[[timelinePosts objectAtIndex:indexPath.row] userProfilePic];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(NSMutableArray *) getPosts
{
    NSMutableArray *list=[[NSMutableArray alloc]init];

    PFQuery *query = [PFQuery queryWithClassName:@"Timeline"];
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByDescending:@"PostDate"];
    
    NSError *error=nil;
    
    NSArray* goals=[query findObjects:&error];
    
    for(PFObject *obj in goals)
    {
        TimelinePost *post=[[TimelinePost alloc]init];
        post.userFirstName=[obj objectForKey:@"userFirstName"];
        post.userLastName=[obj objectForKey:@"userLastName"];
        post.username=[obj objectForKey:@"username"];
        
        post.PostDate=[obj objectForKey:@"PostDate"];
        post.PostContent=[obj objectForKey:@"PostContent"];
        
        PFFile *image = (PFFile *)[obj objectForKey:@"userProfilePic"];
        post.userProfilePic=[UIImage imageWithData:[image getData]];
        
        [list addObject:post];
    }
    
    return list;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectedtimeLinePost.userFirstName=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:indexPath.row] userFirstName]];
    
    selectedtimeLinePost.userLastName=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:indexPath.row] userLastName]];
    
    selectedtimeLinePost.username=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:indexPath.row] username]];
    
    selectedtimeLinePost.userProfilePic=[[timelinePosts objectAtIndex:indexPath.row] userProfilePic];
    
    selectedtimeLinePost.PostDate=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:indexPath.row] PostDate]];
    
    selectedtimeLinePost.PostContent=[NSString stringWithFormat:@"%@",[[timelinePosts objectAtIndex:indexPath.row] PostContent]];


    [self performSegueWithIdentifier:@"TimelinePostToDetails" sender:nil];
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TimelinePostToDetails"])
    {
        TimelinePostDetailsViewController *nav = [segue destinationViewController];
        [nav setCurrentSelectedtimeLinePost:selectedtimeLinePost];
    }
}

@end
