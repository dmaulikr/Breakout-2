//  ViewController.m
//  Breakout
//
//  Created by Glen Ruhl on 7/31/14.
//  Copyright (c) 2014 MM. All rights reserved.

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet BallView *ballView;
@property UIPushBehavior *pushBehavior;
@property UIDynamicAnimator *dynamicAnimator;

@property UIDynamicItemBehavior *paddleDynamicBehavior;
@property UIDynamicItemBehavior *ballDynamicBehavior;
@property UIDynamicItemBehavior *blockDynamicBehavior;

@property UICollisionBehavior *collisionBehavior;
@property UICollisionBehavior *ballBlockCollision;

@property (weak, nonatomic) IBOutlet BlockView *blockView0;
@property (weak, nonatomic) IBOutlet BlockView *blockView1;
@property (weak, nonatomic) IBOutlet BlockView *blockView2;
@property (weak, nonatomic) IBOutlet BlockView *blockView3;
@property (weak, nonatomic) IBOutlet BlockView *blockView4;

@property (weak, nonatomic) IBOutlet BlockView *blockView5;
@property (weak, nonatomic) IBOutlet BlockView *blockView6;
@property (weak, nonatomic) IBOutlet BlockView *blockView7;
@property (weak, nonatomic) IBOutlet BlockView *blockView8;


@property (weak, nonatomic) IBOutlet BlockView *blockView9;
@property (weak, nonatomic) IBOutlet BlockView *blockView10;
@property (weak, nonatomic) IBOutlet BlockView *blockView11;

@property (nonatomic, assign) BOOL shouldStartAgain;

@end


@implementation ViewController {

    NSMutableArray *numberArray;
}


@synthesize shouldStartAgain;

- (void)blockDynamics
{
    self.blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.blockArray];
    self.blockDynamicBehavior.friction = 0;
    self.blockDynamicBehavior.elasticity = 0;
    self.blockDynamicBehavior.density = 1000000;
    [self.dynamicAnimator addBehavior:self.blockDynamicBehavior];
}

- (void)allCollisionBehaviors
{
    //  This right here is all about collision behavior, setting itself as the collision
    //  delegate, setting boundaries and including the paddle and ball as collision-
    //  enabled items.
    
    self.collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.ballView, self.paddleView,
                                                                         [self.blockArray objectAtIndex:0],
                                                                         [self.blockArray objectAtIndex:1],
                                                                         [self.blockArray objectAtIndex:2],
                                                                         [self.blockArray objectAtIndex:3],
                                                                         [self.blockArray objectAtIndex:4],
                                                                         [self.blockArray objectAtIndex:5],
                                                                         [self.blockArray objectAtIndex:6],
                                                                         [self.blockArray objectAtIndex:7],
                                                                         [self.blockArray objectAtIndex:8],
                                                                         [self.blockArray objectAtIndex:9],
                                                                         [self.blockArray objectAtIndex:10],
                                                                         [self.blockArray objectAtIndex:11]]];

    
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
}

- (void)resetBall:(CGPoint)p
{
    //  This method resets the ball when it travels off the frame, and
    //  re-initializes the ball and its behavior for a fresh instance
    //  of the game.

        CGPoint currentVelocity = [self.ballDynamicBehavior linearVelocityForItem:self.ballView];
        [self.ballDynamicBehavior addLinearVelocity:CGPointMake (-currentVelocity.x, -currentVelocity.y)forItem:self.ballView];
        self.ballView.center = CGPointMake(160, 324);
        [self.dynamicAnimator updateItemUsingCurrentState:self.ballView];
        self.pushBehavior.pushDirection = CGVectorMake(.5, 1.0);
        self.pushBehavior.magnitude = 0.1;
        self.pushBehavior.active = YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];


    //  Thinking of replacing the following code with for loop that goes through the subviews on the
    //  superview and adds them to the array if they are of class BlockView.

    self.blockArray = [[NSMutableArray alloc] initWithObjects:self.blockView0, self.blockView1, self.blockView2,
                                                               self.blockView3, self.blockView4, self.blockView5,
                                                               self.blockView6, self.blockView7, self.blockView8,
                                                               self.blockView9, self.blockView10, self.blockView11, nil];

    for (int i = 0; i < 13; i ++) {

        NSNumber *x = [NSNumber numberWithUnsignedInt:(arc4random() % 3 + 1)];
        [numberArray addObject:x];
    }

    //  This sets up the paddle's behavior within the physics of the app.

    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];


    //  Initializes the Animator for the app and adds "pushBehavior," which starts the object moving within the space of the screen.

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.pushDirection = CGVectorMake(2, 1);
    self.pushBehavior.active = YES;
    self.pushBehavior.magnitude = .1;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    [self allCollisionBehaviors];


    //  Defines properties of the ball's movement and behavior within the physics engine of the app.

    self.ballDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ballView]];
    self.ballDynamicBehavior.allowsRotation = NO;
    self.ballDynamicBehavior.friction = 0;
    self.ballDynamicBehavior.elasticity = 1.1;
    self.ballDynamicBehavior.resistance = 0;
    [self.dynamicAnimator addBehavior:self.ballDynamicBehavior];


    self.paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.paddleDynamicBehavior.allowsRotation = NO;
    self.paddleDynamicBehavior.density = 1000000;
    [self.dynamicAnimator addBehavior:self.paddleDynamicBehavior];

    [self blockDynamics];
}

    //  This was our method for resetting the ball after it went offscreen.

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:
        (id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p

{
    if (p.y >= self.view.frame.size.height - 20) {

    [self resetBall:p];
    }
}

    //  Here we defined our method for reloading the blocks on the view. Ideally we will do this
    //  by referencing the blockArray, but since that was giving us issues we decided to handle
    //  other concerns first.


- (void)reloadBlocks
{
    for (BlockView *blockView in self.blockArray) {

        [self.view addSubview:blockView];
        [blockView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
        [blockView setAlpha:1.0];
    }
}

- (void)checkForReset:(CGPoint)p
{
    //  This method checks, after each collision, whether all the blocks are gone from the view. If
    //  they are, it sets shouldStartAgain to be true, calling the ball back to its original location
    //  resetting all the blocks.
    
    if(![self.view.subviews containsObject:self.blockView0] && ![self.view.subviews containsObject:
                                                                 self.blockView1]
       
       && ![self.view.subviews containsObject:self.blockView2] && ![self.view.subviews containsObject:
                                                                    self.blockView3]
       
       && ![self.view.subviews containsObject:self.blockView4] && ![self.view.subviews containsObject:
                                                                    self.blockView5]
       
       && ![self.view.subviews containsObject:self.blockView6] && ![self.view.subviews containsObject:
                                                                    self.blockView7]
       
       && ![self.view.subviews containsObject:self.blockView8] && ![self.view.subviews containsObject:
                                                                    self.blockView9]
       
       && ![self.view.subviews containsObject:self.blockView10] && ![self.view.subviews containsObject:
                                                                     self.blockView11])
    {
        shouldStartAgain = true;
        
        [self blockDynamics];
        [self allCollisionBehaviors];
        [self reloadBlocks];
        [self resetBall:p];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1
                                                                     withItem:(BlockView *)item2
                                                                      atPoint:(CGPoint)p {

    /*  Through testing, we found that in every collision "item1" (as referenced in the
      "beganContactForItem" method) was defined as the ball, and "item2" was whatever
      block was being hit. We used that understanding to remove whichever block was
      being hit when it was hit. */

    for (BlockView *blockView in self.blockArray) {

        
        if ([item2 isEqual:blockView]) {



            for (int i = 0; i < self.blockArray.count; i ++) {

                if ([[self.blockArray objectAtIndex:i] isEqual:item2]) {

                    NSLog(@"index is %i", i);
                }

            }

            /* The following line will contain the completion block for the
            animation that will take place when the BlockView is removed from the superview. */

            [[item2 class] animateWithDuration:0.4 animations:^{

                item2.backgroundColor = [UIColor whiteColor];
                item2.alpha = 0.5;
                [self.collisionBehavior removeItem:item2];

            } completion:^(BOOL finished) {

                [item2 removeFromSuperview];
                [self checkForReset:p];
            }];
        }

    }

}

//  This is the method that enables the paddle to be moved across the screen with the PanGestureRecognizer.

-(IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer

{
    self.paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

@end