//
//  ViewController.m
//  Breakout
//
//  Created by Glen Ruhl on 7/31/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

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
@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property (weak, nonatomic) IBOutlet BlockView *blockView1;
@property BOOL *viewsDoCollide;
@end

@implementation ViewController

- (void)viewDidLoad
{

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.29 green:0.4 blue:0.62 alpha:1];

    self.blockArray = [[NSMutableArray alloc] initWithObjects:self.blockView, self.blockView1, nil];


    //  This sets up the paddle's behavior within the physics of the app.

    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];

    //  Initializes the Animator for the app and adds "pushBehavior," which starts the object moving within the space of the screen.

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.pushDirection = CGVectorMake(2, 1);
    self.pushBehavior.active = YES;
    self.pushBehavior.magnitude = .5;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    //  This right here is all about collision behavior, setting itself as the collision
    //  delegate, setting boundaries and including the paddle and ball as collision-
    //  enabled items.

    self.collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.ballView, self.paddleView, self.blockView, self.blockView1]];
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];

    //  Defines properties of the ball's movement and behavior within the physics engine of the app.

    self.ballDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ballView]];
    self.ballDynamicBehavior.allowsRotation = NO;
    self.ballDynamicBehavior.friction = 0;
    self.ballDynamicBehavior.elasticity = 1.0;
    self.ballDynamicBehavior.resistance = 0;
    [self.dynamicAnimator addBehavior:self.ballDynamicBehavior];


    self.paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.paddleDynamicBehavior.allowsRotation = NO;
    self.paddleDynamicBehavior.density = 1000000;
    [self.dynamicAnimator addBehavior:self.paddleDynamicBehavior];
    self.paddleView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];

    [self.dynamicAnimator addBehavior:self.paddleDynamicBehavior];

    //  The blockView code block. From the block.

    self.blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.blockArray];
    self.blockDynamicBehavior.allowsRotation = NO;
    self.blockDynamicBehavior.friction = 0;
    self.blockDynamicBehavior.elasticity = 0;
    self.blockDynamicBehavior.density = 1000000;
    [self.dynamicAnimator addBehavior:self.blockDynamicBehavior];
    [self.dynamicAnimator updateItemUsingCurrentState:self.blockView];

}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:
        (id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p

{
    NSLog(@"GO!");
    //  This method resets the ball when it travels off the frame, and
    //  re-initializes the ball and its behavior for a fresh instance
    //  of the game.

    if (p.y >= self.view.frame.size.height - 20) {
        CGPoint currentVelocity = [self.ballDynamicBehavior linearVelocityForItem:self.ballView];
        [self.ballDynamicBehavior addLinearVelocity:CGPointMake (-currentVelocity.x, -currentVelocity.y)forItem:self.ballView];
        self.ballView.center = CGPointMake(160, 258);
        [self.dynamicAnimator updateItemUsingCurrentState:self.ballView];
        self.pushBehavior.pushDirection = CGVectorMake(.5, 1.0);
        self.pushBehavior.magnitude = 0.5;
        self.pushBehavior.active = YES;
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if (!([item1 isEqual:self.paddleView] || [item2 isEqual:self.paddleView])) {
        [self.blockView removeFromSuperview];
        [self.collisionBehavior removeItem:self.blockView];

        [self.blockView1 removeFromSuperview];
        [self.collisionBehavior removeItem:self.blockView1];
    }
}
    //  This is the method that enables the paddle to be moved across the screen with the PanGestureRecognizer.

-(IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer

{
    self.paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

@end