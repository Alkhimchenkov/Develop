//
//  Panel.m
//  PopoverTest
//
//  Created by Андрей on 24.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "Panel.h"

@implementation Panel

+(Panel*)createWithParentView:(UIView *)parent{

    Panel *paneView = (Panel *)[[NSBundle bundleForClass:self] loadNibNamed:@"PaneView" owner:self options:nil].lastObject;

    // Add to super view and tell to autoresizing masks to prevent constraints creation
    [parent addSubview:paneView];
    CGRect frame = paneView.frame;
    CGRect frameParent = parent.frame;
    frame.size.width = frameParent.size.width * 2;
    frame.size.height = frameParent.size.height;
    [paneView setFrame:frame];
    
    // Animate fade-in
    paneView.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        paneView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    return paneView;
    
}

@end
