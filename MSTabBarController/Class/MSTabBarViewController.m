//
//  MSTabBarViewController.m
//  MSCustomTabBar
//
//  Created by Marshal on 15/12/24.
//  Copyright © 2015年 Marshal. All rights reserved.
//

#import "MSTabBarViewController.h"

#import "JSBadgeView.h"
#import "CustomerNavigationController.h"

@interface MSTabBarViewController ()<UITabBarControllerDelegate>
{
    CGAffineTransform trans;
}
/**
 *  背景视图：
 */
@property (nonatomic,strong) UIView * BackgroundView;
/**
 *  背景图片
 */
//@property (nonatomic,strong) UIImageView * imageView;
/**
 *  标题
 */
@property (nonatomic,strong) NSArray * titles;
/**
 *  @author Marshal, 16-01-04 13:01:00
 *
 *  @brief 选中状态
 */
@property (nonatomic, weak) UIButton *selectedButton;

@property(nonatomic,strong) ModalTransitionAnimation *animation;

@end

@implementation MSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
   
    /**
     *  加载控制器：
     */
    [self loadControllers];
    /**
     *  自定义TabBar
     */
    [self creationCusTabBar];
    

    
}

#pragma mark - === 创建控制器  ===
- (void)loadControllers
{
    
    OneViewController * oneVC = [[OneViewController alloc]init];
    oneVC.title = @"测试一";
    TwoViewController * twoVC = [[TwoViewController alloc]init];
    twoVC.title = @"测试二";
    ThreeViewController * three = [[ThreeViewController alloc]init];
    three.title = @"测试三";
    TwoViewController * four = [[TwoViewController alloc]init];
    four.title = @"测试四";
    ThreeViewController * five = [[ThreeViewController alloc]init];
    five.title = @"测试五";
    
    CustomerNavigationController * nav1 = [[CustomerNavigationController alloc]initWithRootViewController:oneVC];
    [nav1.navigationBar setBarTintColor:[UIColor cyanColor]];
    
    CustomerNavigationController * nav2 = [[CustomerNavigationController alloc]initWithRootViewController:twoVC];
    [nav2.navigationBar setBarTintColor:[UIColor yellowColor]];
    
    CustomerNavigationController * nav3 = [[CustomerNavigationController alloc]initWithRootViewController:three];
    [nav3.navigationBar setBarTintColor:[UIColor redColor]];
    
    CustomerNavigationController * nav4 = [[CustomerNavigationController alloc]initWithRootViewController:four];
    [nav4.navigationBar setBarTintColor:[UIColor blueColor]];
    
    CustomerNavigationController * nav5 = [[CustomerNavigationController alloc]initWithRootViewController:five];
    [nav5.navigationBar setBarTintColor:[UIColor redColor]];
    
    //添加控制器
    self.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
    
    
    for (UIView * view in self.tabBar.subviews)
    {
        [view removeFromSuperview];
    }
    //隐藏系统的
//    self.tabBar.hidden = YES;
    NSLog(@"-----%@",NSStringFromCGRect(self.tabBar.frame));
    _BackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
//    _BackgroundView.backgroundColor = ColorWithRGB(238, 238, 238, 1.0);
    
//    [self.view addSubview:_BackgroundView];
    [self.tabBar addSubview:_BackgroundView];
    
//    _imageView = [[UIImageView alloc]initWithFrame:_BackgroundView.bounds];
//    _imageView.image = [UIImage imageNamed:@"tab_background"];
//    _imageView.userInteractionEnabled = YES;
//    [_BackgroundView addSubview:_imageView];
    /**
     *  保持transform
     */
     trans = _BackgroundView.transform;
}


#pragma mark - === 自定义的TabBar ==
- (void)creationCusTabBar
{

    _titles = @[@"测试一",@"测试二",@"测试三",@"测试四",@"测试五"];
    NSArray * norImages = @[@"tabbar_contacts",@"tabbar_discover",@"tabbar_mainframe",@"tabbar_mainframe",@"tabbar_mainframe"];
    //按钮宽度
    CGFloat width = ScreenWidth / _titles.count;
    
    
    for (NSInteger i = 0; i<_titles.count; i++)
    {
        //按钮：
        TabBarButton * btn = [TabBarButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [[UIImage imageNamed:[norImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [btn setImage:image  forState:UIControlStateNormal];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        btn.imageView.tintColor = [UIColor orangeColor];
        [btn setImage:image forState:UIControlStateSelected];
        [btn setImage:image forState:UIControlStateSelected | UIControlStateHighlighted];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:[_titles objectAtIndex:i]forState:UIControlStateNormal];
        [btn setTintColor:[UIColor blackColor]];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected | UIControlStateHighlighted];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btn.tag = i+100;
        
        [btn addTarget:self action:@selector(TapBnt:) forControlEvents:UIControlEventTouchDown];
        
        btn.frame = CGRectMake(width*i, 0, width, _BackgroundView.frame.size.height);
        
        
        [_BackgroundView addSubview:btn];
        if (i == 0) {
            [self TapBnt:btn];
        }
        
    }
    
}

#pragma mark - === 逻辑处理 ====
/**
 *  点击按钮，切换控制器：
 */
- (void)TapBnt: (UIButton *)sender
{
    if (sender.isSelected){
        return;
    }
    UIImageView *selectedImageView = sender.imageView;
    UILabel *selectedLabel = sender.titleLabel;
    
    UIImageView *deSelectedImageView = self.selectedButton.imageView;
    UILabel *deSelectedLabel = self.selectedButton.titleLabel;
    
    
    if (sender.tag - 100 == 2) {
        [self playMoveIconAnimation:selectedImageView values:@[@(deSelectedImageView.center.y),@(deSelectedImageView.center.y+8.0)]];
        [self playAnimationWithView:selectedLabel];
        
    }
    else{
        if (sender.tag - 100 == 0 || sender.tag - 100 == 4) {
            [self playTransitionAniamtions:selectedImageView];
        }else{
            [self playBounceAnimation:selectedImageView];
        }
        if (self.selectedIndex == 2) {
            //1.deselectAnimation
            [self playMoveIconAnimation:deSelectedImageView values:@[@(deSelectedImageView.center.y + 8.0),@(deSelectedImageView.center.y)]];
            [self playDeselectLabelAnimation:deSelectedLabel];
        }
    }
    
    
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    
    self.selectedIndex = sender.tag - 100;
    self.selectedButton = sender;
    
}

- (void)setBadge:(NSString *)badge atIndex:(NSInteger)index{
    for (UIButton *buttonItem in self.BackgroundView.subviews) {
        if (index == buttonItem.tag - 100) {
            for (UIView *sub in buttonItem.imageView.subviews) {
                if ([sub isKindOfClass:[JSBadgeView class]]) {
                    [sub removeFromSuperview];
                    break;
                }
            }
            if (badge != nil) {
                JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:buttonItem.imageView alignment:JSBadgeViewAlignmentTopRight];
                badgeView.badgeText = badge;
                badgeView.badgePositionAdjustment = CGPointMake(0, 6);
                badgeView.badgeTextFont = [UIFont systemFontOfSize:12];
                break;
            }
        }
    }
}

#pragma mark - == 显示或隐藏TabBar ===

- (void)HideTabarView:(BOOL)isHideen  animated:(BOOL)animated;
{
    //隐藏
    if (isHideen == YES)
    {
        //需要动画
        if (animated)
        {
            [UIView animateWithDuration:0.6 animations:^{
                
            _BackgroundView.transform = CGAffineTransformTranslate(_BackgroundView.transform, 0,_BackgroundView.frame.size.height);
            _BackgroundView.alpha = 0;
            }];
        }
        //没有动画
        else
        {
   
            _BackgroundView.alpha = 0;
        }
    }
    //显示
    else
    {
        //需要动画
        if (animated)
        {
            [UIView animateWithDuration:0.6 animations:^{
                
                _BackgroundView.alpha = 1.0;
                _BackgroundView.transform = trans;
            }];
        }
        //没有动画
        else
        {
            _BackgroundView.alpha = 1.0;
            _BackgroundView.transform = trans;
        }
    }
}

static const CGFloat duration = 0.5;
#pragma mark - 位移动画
- (void)playAnimationWithView:(UILabel *)view{
    
    CAKeyframeAnimation *yPositionAnimation = [self createAnimationWithKeyPath:@"position.y" Values:@[@(view.center.y),@(view.center.y - 60.0)] duration:duration];
    yPositionAnimation.fillMode = kCAFillModeRemoved;
    yPositionAnimation.removedOnCompletion = true;
    [view.layer addAnimation:yPositionAnimation forKey:@"yLabelPostionAnimation"];
    
    CAKeyframeAnimation *scaleAnimation = [self createAnimationWithKeyPath:@"transform.scale" Values:@[@1.0,@2.0] duration:duration];
    scaleAnimation.fillMode = kCAFillModeRemoved;
    scaleAnimation.removedOnCompletion = true;
    [view.layer addAnimation:scaleAnimation forKey:@"scaleLabelAnimation"];
    
    CAKeyframeAnimation *opacityAnimation = [self createAnimationWithKeyPath:@"opacity" Values:@[@1.0,@0.0] duration:duration];
    [view.layer addAnimation:opacityAnimation forKey:@"opacityLabelAnimation"];
}
- (void)playDeselectLabelAnimation:(UILabel *)label{
    
    CAKeyframeAnimation *yPositionAnimation = [self createAnimationWithKeyPath:@"position.y" Values:@[@(label.center.y + 15),@(label.center.y)] duration:duration];
    [label.layer addAnimation:yPositionAnimation forKey:@"yLabelPostionAnimation"];
    CAKeyframeAnimation *opacityAnimation = [self createAnimationWithKeyPath:@"opacity" Values:@[@0.0,@1.0] duration:duration];
    [label.layer addAnimation:opacityAnimation forKey:@"opacityLabelAnimation"];
}
- (void)playMoveIconAnimation:(UIImageView *)icon values:(NSArray *)values{
    CAKeyframeAnimation *yPositionAnimation = [self createAnimationWithKeyPath:@"position.y" Values:values duration:duration];
    [icon.layer addAnimation:yPositionAnimation forKey:@"yPositionAnimation"];
}

- (CAKeyframeAnimation *)createAnimationWithKeyPath:(NSString *)keyPath Values:(NSArray *)values duration:(CGFloat)duration{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.values = values;
    animation.duration = duration;
    animation.calculationMode = kCAAnimationCubic;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}
#pragma mark - 缩放动画
- (void)playBounceAnimation:(UIImageView *)icon{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@1.0 ,@1.3, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = .7;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [icon.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
}
#pragma mark - 翻转动画
- (void)playTransitionAniamtions:(UIImageView *)icon{
    [UIView transitionWithView:icon duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
}
#pragma mark - 转场动画
- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (self.animation == nil) {
        _animation = [[ModalTransitionAnimation alloc] init];
    }
    UIViewController *vc = [((UINavigationController *)toVC).viewControllers firstObject];
    if ([vc isKindOfClass:[ThreeViewController class]]) {
        _animation.animationType = Value1;
    }else{
        _animation.animationType = Value2;
    }
    return _animation;
}


@end

static const CGFloat margin = 5;
static const CGFloat titleHeight = 20;
@implementation TabBarButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    
    return CGRectMake(0, contentRect.size.height-titleHeight, contentRect.size.width, titleHeight);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake((contentRect.size.width - self.currentImage.size.width)*0.5 , margin, self.currentImage.size.width, self.currentImage.size.height);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.clipsToBounds = NO;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
//ModalTransitionAnimation.m
@implementation ModalTransitionAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    switch (self.animationType) {
        case Value1:{
            /**
             *  @author Marshal, 16-01-07 10:01:07
             *
             *  @brief 兼容ios7
             */
//            UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//            UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
            UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
            
            [[transitionContext containerView] addSubview:fromView];
            [[transitionContext containerView] addSubview:toView];
            
            CGFloat finalRadius = sqrt(pow(toView.frame.size.height, 2) + pow(toView.frame.size.width, 2));
            
            UIBezierPath *start = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(toView.center.x, toView.center.y, 0, 0)];
            
            UIBezierPath *final = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(toView.center.x - finalRadius, toView.center.y - finalRadius, finalRadius * 2, finalRadius * 2)];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.fillColor = [UIColor whiteColor].CGColor;
            maskLayer.path = final.CGPath;
            toView.layer.mask = maskLayer;
            
            CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            maskLayerAnimation.delegate = self;
            maskLayerAnimation.fromValue = (__bridge id)(start.CGPath);
            maskLayerAnimation.toValue = (__bridge id)((final.CGPath));
            maskLayerAnimation.duration = [self transitionDuration:transitionContext];
            maskLayerAnimation.delegate = self;
            maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
            [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
        }
            
            break;
        case Value2:{
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
            
            
            toVC.view.frame = CGRectOffset(finalFrame, 0, -finalFrame.size.height);
            
            UIView *containerView = [transitionContext containerView];
            [containerView addSubview:toVC.view];
            
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 toVC.view.frame = finalFrame;
                             } completion:^(BOOL finished) {
                                 [transitionContext completeTransition:YES];
                             }];
        }
            
            break;
        case Value3:
            
            break;
            
        default:
            break;
    }
    
    
    
    
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    if (transitionContext != nil) {
        [transitionContext completeTransition:YES];
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        }
    }
}



@end







