//
//  UIImage+ResizeImage.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/23/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeImage)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
