//
//  UtilitiesGradient.m
//  loginapp
//
//  Created by Vadim on 12/26/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "UtilitiesGradient.h"

@implementation UtilitiesGradient



+(void)designSketch:(UIImageView *)imageView
{
    CAGradientLayer *gradientLayer =[CAGradientLayer layer];
    gradientLayer.frame = imageView.bounds;
    gradientLayer.colors = @[(id)[[UIColor colorWithRed:(151/255.0) green:(157/255.0) blue:(183/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(146/255.0) green:(159/255.0) blue:(182/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(145/255.0) green:(170/255.0) blue:(194/255.0) alpha:0.9] CGColor]];
    [imageView.layer addSublayer:gradientLayer];
}

@end
