//
//  BlockView.h
//  Breakout
//
//  Created by Albert Saucedo on 8/1/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BlockViewDelegate

-(void) checkCollision;

@end


@interface BlockView : UIView

@property id <BlockViewDelegate> delegate;

@end
