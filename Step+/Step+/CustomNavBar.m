

#import "CustomNavBar.h"

@implementation CustomNavBar

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:@"SignupNavigationBar.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
