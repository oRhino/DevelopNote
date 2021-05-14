//
//  UIGestureRecognizer+SensorsData.m
//  SensorsSDK
//
//  Created by hx on 2021/5/14.
//

#import "UIGestureRecognizer+SensorsData.h"
#import "NSObject+SASwizzler.h"
#import "SensorsAnalyticsSDK.h"

@implementation UITapGestureRecognizer (SensorsData)


+ (void)load{
    
    [UITapGestureRecognizer sensorsdata_swizzleMethod:@selector(initWithTarget:action:) withMethod:@selector(sensorsdata_initWithTarget:action:)];
    [UITapGestureRecognizer sensorsdata_swizzleMethod:@selector(addTarget:action:) withMethod:@selector(sensorsdata_addTarget:action:)];
}

- (instancetype)sensorsdata_initWithTarget:(id)target action:(SEL)action{
    // 调用原始的初始化方法进行对象初始化
    [self sensorsdata_initWithTarget:target action:action];
    // 调用添加Target-Action的方法，添加埋点的Target-Action
    // 这里其实调用的是-sensorsdata_addTarget:action:的实现方法，因为已经进行交换
    [self addTarget:target action:action];
    return self;
}


- (void)sensorsdata_addTarget:(id)target action:(SEL)action{
    // 调用原始的方法，添加Target-Action
    [self sensorsdata_addTarget:target action:action];
    // 新增Target-Action ，用于触发$AppClick事件
    [self sensorsdata_addTarget:self action:@selector(sensorsdata_trackTapGestureAction:)];
}


- (void)sensorsdata_trackTapGestureAction:(UITapGestureRecognizer *)sender{
    //获取手势识别器的控件
    UIView *view = sender.view;
    // 暂定只采集UILabel和UIImageView
    BOOL isTrackClass = ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]);
    if (!isTrackClass) {
        return;
    }
    /////采集
    [[SensorsAnalyticsSDK sharedInstance] tracckAppClickWithView:view properties:nil];
}

@end


@implementation UILongPressGestureRecognizer (SensorsData)

+ (void)load{
    /// Swizzle initWithTarget:action:方法
    [UILongPressGestureRecognizer sensorsdata_swizzleMethod:@selector(initWithTarget:action:) withMethod:@selector(sensorsdata_initWithTarget:action:)];
    ////Swizzle addTarget:action:方法
    [UILongPressGestureRecognizer sensorsdata_swizzleMethod:@selector(addTarget:action:) withMethod:@selector(sensorsdata_addTarget:action:)];
}

- (instancetype)sensorsdata_initWithTarget:(id)target action:(SEL)action{
    // 调用原始的初始化方法进行对象初始化
    [self sensorsdata_initWithTarget:target action:action];
    // 调用添加Target-Action的方法，添加埋点的Target-Action
    // 这里其实调用的是-sensorsdata_addTarget:action:的实现方法，因为已经进行交换
    [self addTarget:target action:action];
    return self;
}


- (void)sensorsdata_addTarget:(id)target action:(SEL)action{
    // 调用原始的方法，添加Target-Action
    [self sensorsdata_addTarget:target action:action];
    // 新增Target-Action ，用于触发$AppClick事件
    [self sensorsdata_addTarget:self action:@selector(sensorsdata_trackLongPressGestureAction:)];
}


- (void)sensorsdata_trackLongPressGestureAction:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    //获取手势识别器的控件
    UIView *view = sender.view;
    // 暂定只采集UILabel和UIImageView
    BOOL isTrackClass = ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]);
    if (!isTrackClass) {
        return;
    }
    /////采集
    [[SensorsAnalyticsSDK sharedInstance] tracckAppClickWithView:view properties:nil];
}

    
@end
