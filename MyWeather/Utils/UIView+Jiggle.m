//
//  UIView+Jiggle.m
//  MyChild
//
//  Created by Francis Ye on 8/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Jiggle.h"
#import "QuartzCore/QuartzCore.h"
#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDegree 1.0

@implementation UIView (Jiggle)
- (void)startJiggling
{
    int random = arc4random() % 500;
    float r = random / 500.0f;
    
    CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( (kAnimationRotateDegree * -1.0) - r ));
    CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDegree + r ));
    
    int startSide = arc4random() % 2;
    if (0 == startSide) {
        self.transform = leftWobble;
    } else {
        self.transform = rightWobble;
    }
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{ 
                         [UIView setAnimationRepeatCount:NSNotFound];
                         if (0 == startSide) {
                             self.transform = rightWobble;
                         } else {
                             self.transform = leftWobble;
                         }
                     }
                     completion:nil];
}

- (void)stopJiggling
{
    [self.layer removeAllAnimations];
    [self setTransform:CGAffineTransformIdentity];
}
@end
