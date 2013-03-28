//
//  ShakeView.m
//  WeThePeople
//
//  Created by Robert Eickmann on 3/27/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import "ShakeView.h"
#import "ATConnect.h"

@implementation ShakeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        ATConnect *connection = [ATConnect sharedConnection];
        [connection presentFeedbackControllerFromViewController:self];
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
