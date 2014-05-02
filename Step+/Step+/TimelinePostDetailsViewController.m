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
@synthesize currentSelectedtimeLinePost;
@synthesize avatar;
@synthesize avatar2;


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
    self.sendBu.enabled=NO;
    [self getPostsCommments];
    [self.tableview reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.postusername.text=[NSString stringWithFormat:@"%@ %@",self.currentSelectedtimeLinePost.userFirstName,self.currentSelectedtimeLinePost.userLastName];
    
    self.postContent.text=[NSString stringWithFormat:@"%@",self.currentSelectedtimeLinePost.PostContent];
    
    self.userPostDate.text=[NSString stringWithFormat:@"%@",[self GetTimeinWords:self.currentSelectedtimeLinePost.PostDate]];
    
    
    [avatar removeFromSuperview];
    avatar = [[AMPAvatarView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    avatar.image=self.currentSelectedtimeLinePost.userProfilePic;
    [self.userProfiePic addSubview:avatar];
    
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"fffcfc"];
    
    [self getPostsCommments];
    
    [self.tableview reloadData];
    [self.commentTextField becomeFirstResponder];
    
    self.tableview.separatorColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];

    
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
    [newPostComment setObject:self.currentSelectedtimeLinePost.PostOtherRelatedInFormationContent forKey:@"ItemID"];
    
    
    NSData *pictureData = UIImagePNGRepresentation(currentUser.userProfileImage);
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [newPostComment setObject:file forKey:@"FromuserProfilePic"];
        [newPostComment saveEventually];
        
    }];
    
    
     [[self.currentSelectedtimeLinePost whoCommentPost] addObject:currentUser.userUsername];
    

    [self.currentSelectedtimeLinePost UpdatePostComments];

    PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query whereKey:@"progressID" equalTo:[NSString stringWithFormat:@"%@",self.currentSelectedtimeLinePost.PostOtherRelatedInFormationContent]];
    
    [query whereKey:@"createdBy" equalTo:self.currentSelectedtimeLinePost.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * updateGoals, NSError *error){
        if (!error) {
            
            for (PFObject* obj in updateGoals)
            {
                NSString *temp=[obj objectForKey:@"numberOfComments"];
                NSInteger Nummber=[temp integerValue]+1;
               // NSLog(@"%d",Nummber);
                
                [obj setObject:[NSString stringWithFormat:@"%d",Nummber] forKey:@"numberOfComments"];
                
                [obj saveEventually];
            }
        }
    }];
    
    [self.tableview reloadData];
    

    
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void) getPostsCommments
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"PostComment"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"To" equalTo:self.currentSelectedtimeLinePost.username];
    [query whereKey:@"PostID" equalTo:self.currentSelectedtimeLinePost.postID];
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(findCallback:error:)];
}

- (void)findCallback:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        
    //NSLog(@"currentSelectedtimeLinePost %@",currentSelectedtimeLinePost.username);
    
    TimelinePostComments=[[NSMutableArray alloc]init];
    
    for(PFObject *obj in objects)
    {
        timelinePostComment *postcomment=[[timelinePostComment alloc]init];
        
        postcomment.To=[obj objectForKey:@"To"];
        postcomment.From=[obj objectForKey:@"From"];
        postcomment.commentContent=[obj objectForKey:@"commentContent"];
        postcomment.PostID=[obj objectForKey:@"PostID"];
        PFFile *image = (PFFile *)[obj objectForKey:@"FromuserProfilePic"];
        postcomment.FromuserProfilePic=[UIImage imageWithData:[image getData]];
        
        [TimelinePostComments addObject:postcomment];
    }
        [self.tableview reloadData];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"TimelinePostCommentTableViewCell";
    
    TimelinePostCommentTableViewCell *cell = (TimelinePostCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelinePostCommentTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.FromUserComment.text=[NSString stringWithFormat:@"%@",[[TimelinePostComments objectAtIndex:indexPath.row] commentContent]];
    
    
    avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];

    avatar2.image=[[TimelinePostComments objectAtIndex:indexPath.row] FromuserProfilePic];
    
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
   // NSLog(@"isPressed");

    //NSLog(@"%d",row);
    currentUsername=[[TimelinePostComments objectAtIndex:row] From];
    [self performSegueWithIdentifier:@"GoToUserProfile" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoToUserProfile"])
    {
        UINavigationController *nav = [segue destinationViewController];
        UserProfileViewController*vc = (UserProfileViewController*)nav.topViewController;
        [vc setSelectedUsername:self.currentUsername];
        [vc setCurrentUser:currentUser];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


-(NSString *) GetTimeinWords: (NSString *) Y
{
    //NSLog(@"rrr");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *dateFromString = [[NSDate alloc]init];
    
    dateFromString = [dateFormatter dateFromString:Y];
    
    NSString * I=[dateFromString prettyDate];
    
    
    return I;
}

- (void)touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (! [self isFirstResponder])
    {
            if ([self.commentTextField isFirstResponder])
            {
                [self.commentTextField resignFirstResponder];
            
            }
    }
}


-(IBAction)editingChanged
{
    // make sure all fields are have something in them
    
    if (self.commentTextField.text.length > 0)
    {
        self.sendBu.enabled=YES;
    }
    else
    {
        self.sendBu.enabled=NO;
    }
}


@end
