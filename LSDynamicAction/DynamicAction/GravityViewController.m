//
//  GravityViewController.m
//  DynamicAction
//
//

#import "GravityViewController.h"
#import "YYView.h"
#import <CoreMotion/CoreMotion.h>

@interface GravityViewController ()
@property (weak, nonatomic) IBOutlet UIView *funcView;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) UIGravityBehavior *gravity;

@property (strong, nonatomic) UICollisionBehavior *collision;

@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation GravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    
    CGFloat width=self.view.bounds.size.width;
//    [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, 200) ];
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 40)];
    [path addLineToPoint:CGPointMake(0, 100)];
    [path addLineToPoint:CGPointMake(width, 400)];
    [path addLineToPoint:CGPointMake(width,40 )];
    CAShapeLayer *layer=[CAShapeLayer layer];
    layer.path =path.CGPath;
    layer.fillColor=[UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:layer];

    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSInteger count = 5;
    CGFloat itemW = 30;
    NSMutableArray <UIView *>* items = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        CGFloat X = i % 10 * itemW;
        CGFloat Y = (35 + i / 10);
        
        YYView *view = [[YYView alloc] initWithFrame:CGRectMake(X, Y, itemW, itemW)];
        view.layer.cornerRadius = itemW / 2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.lightGrayColor.CGColor;
        view.layer.masksToBounds = YES;
//        [self.view insertSubview:view belowSubview:_funcView];
        [self.view addSubview:view];
        
        [items addObject:view];
    }
    //重力行为
    _gravity = [[UIGravityBehavior alloc] initWithItems:items];
    [_animator addBehavior:_gravity];
    
    
    //碰撞行为  控制掉落的区域范围
    _collision = [[UICollisionBehavior alloc] initWithItems:items];
    
  
    
    
    [_collision addBoundaryWithIdentifier:@"view" forPath:path];
    
    
    
    
//    _collision.translatesReferenceBoundsIntoBoundary=NO;
    [_animator addBehavior:_collision];
    
    //弹性行为
    _itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    _itemBehavior.elasticity = 0.5;
    _itemBehavior.allowsRotation = YES;
    [_animator addBehavior:_itemBehavior];
    
    _motionManager = [[CMMotionManager alloc] init];
    
    if (_motionManager.deviceMotionAvailable) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [_motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _gravity.gravityDirection = CGVectorMake(motion.gravity.x, -motion.gravity.y);
                });
            }
        }];
    }else{
        NSLog(@"deviceMotion不可用");
    }
    
    
    
}

#if TARGET_IPHONE_SIMULATOR

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGVector ve0 = CGVectorMake(0, 1);
    CGVector ve1 = CGVectorMake(1, 0);
    CGVector ve2 = CGVectorMake(0, -1);
    CGVector ve3 = CGVectorMake(-1, 0);
    if (CGVectorEqualToVector(_gravity.gravityDirection, ve0)) {
        _gravity.gravityDirection = ve1;
    } else if (CGVectorEqualToVector(_gravity.gravityDirection, ve1)) {
        _gravity.gravityDirection = ve2;
    } else if (CGVectorEqualToVector(_gravity.gravityDirection, ve2)) {
        _gravity.gravityDirection = ve3;
    } else if (CGVectorEqualToVector(_gravity.gravityDirection, ve3)) {
        _gravity.gravityDirection = ve0;
    }
}

NS_INLINE BOOL CGVectorEqualToVector(CGVector vector0, CGVector vector1) {
    return (vector0.dx == vector1.dx) && (vector0.dy == vector1.dy);
}

#endif

- (IBAction)dismissClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addButtonClick:(UIButton *)sender {
    NSInteger count = 10;
    CGFloat itemW = 30;
    
    for (NSInteger i = 0; i < count; i ++) {
        CGFloat X = i % 10 * itemW;
        CGFloat Y = (35 + i / 10);
        
        YYView *view = [[YYView alloc] initWithFrame:CGRectMake(X, Y, itemW, itemW)];
        view.layer.cornerRadius = itemW / 2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.lightGrayColor.CGColor;
        view.layer.masksToBounds = YES;
        [self.view insertSubview:view belowSubview:_funcView];
        
        [_collision addItem:view];
        [_gravity addItem:view];
        [_itemBehavior addItem:view];
    }
    
}

@end
