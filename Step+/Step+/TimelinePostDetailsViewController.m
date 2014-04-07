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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
