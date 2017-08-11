//
//  YYView.m
//  DynamicAction
//
//

#import "YYView.h"

@implementation YYView

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.layer.cornerRadius = self.frame.size.width / 2;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = UIColor.lightGrayColor.CGColor;
//    self.layer.masksToBounds = YES;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"left_wheel"].CGImage);
    }
    return self;
}

- (UIDynamicItemCollisionBoundsType)collisionBoundsType {
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

-(UIBezierPath *)collisionBoundingPath
{
    return nil;
}
@end
