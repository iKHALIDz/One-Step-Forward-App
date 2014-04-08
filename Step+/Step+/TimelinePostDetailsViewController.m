//
//  TimelinePostDetailsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "TimelinePostDetailsViewController.h"

@interface TimelinePostDetailsViewController ()


@end

@implementation TimelinePostDetailsViewController

@synthesize currentUser;
@synthesize TimelinePostComments;
@synthesize currentUsername;

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
    
    self.postusername.text=[NSString stringWithFormat:@"%@ %@",self.currentSelectedtimeLinePost.userFirstName,self.currentSelectedtimeLinePost.userLastName];
    
    self.postContent.text=[NSString stringWithFormat:@"%@",self.currentSelectedtimeLinePost.PostContent];
    
    self.userPostDate.text=[NSString stringWithFormat:@"%@",self.currentSelectedtimeLinePost.PostDate];
    
    
    self.userpic.image=self.currentSelectedtimeLinePost.userProfilePic;
    
    TimelinePostComments=[[NSMutableArray alloc]init];
    
    TimelinePostComments=[self getPostsCommments];
    
    [self.tableview reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [TimelinePostComments count];
}


- (IBAction)sendComment:(UIButton *)sender {
    
    PFObject *newPostComment = [PFObject objectWithClassName:@"PostComment"];
    
    [newPostComment setObject:self.currentSelectedtimeLinePost.username forKey:@"To"];
    [newPostComment setObject:currentUser.userUsername forKey:@"From"];
    [newPostComment setObject:self.commentTextField.text forKey:@"commentContent"];
    [newPostComment setObject:self.currentSelectedtimeLinePost.postID forKey:@"PostID"];
    
    NSData *pictureData = UIImagePNGRepresentation(currentUser.userProfileImage);
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [newPostComment setObject:file forKey:@"FromuserProfilePic"];
        [newPostComment saveEventually];
    }];
}

-(NSMutableArray *) getPostsCommments
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PostComment"];
    [query whereKey:@"To" equalTo:self.currentSelectedtimeLinePost.username];
    [query whereKey:@"PostID" equalTo:self.currentSelectedtimeLinePost.postID];
    
    NSLog(@"currentSelectedtimeLinePost %@",_currentSelectedtimeLinePost.username);
    
    NSError *error=nil;
    
    NSArray* goals=[query findObjects:&error];
    
    for(PFObject *obj in goals)
    {
        timelinePostComment *postcomment=[[timelinePostComment alloc]init];
        
        postcomment.To=[obj objectForKey:@"To"];
        postcomment.From=[obj objectForKey:@"From"];
        postcomment.commentContent=[obj objectForKey:@"commentContent"];
        postcomment.PostID=[obj objectForKey:@"PostID"];
        PFFile *image = (PFFile *)[obj objectForKey:@"FromuserProfilePic"];
        postcomment.FromuserProfilePic=[UIImage imageWithData:[image getData]];
        
        [list addObject:postcomment];
    }
    
    return list;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"TimelinePostCommentTableViewCell";
    
    TimelinePostCommentTableViewCell *cell = (TimelinePostCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelinePostCommentTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.FromUserComment.text=[NSString stringWithFormat:@"%@",[[TimelinePostComments objectAtIndex:indexPath.row] commentContent]];
    
    cell.FromUserimage.image=[[TimelinePostComments objectAtIndex:indexPath.row] FromuserProfilePic];
    
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
    currentUsername=[[TimelinePostComments objectAtIndex:row] From];
    [self performSegueWithIdentifier:@"GoToUserProfile" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    if ([[segue identifier] isEqualToString:@"GoToUserProfile"])
    {
        UserProfileViewController *nav = [segue destinationViewController];
        [nav setSelectedUsername:currentUsername];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
