//
//  XMNWebProgressView.h
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import <UIKit/UIKit.h>


/**
 显示网路请求进度条
 */
@interface XMNWebProgressView : UIView

/** 进度条当前进度 */
@property (assign, nonatomic) float progress;

/** 进度条颜色 */
@property (strong, nonatomic) UIColor *progressColor;
/** bar动画时长  默认.1f */
@property (assign, nonatomic) NSTimeInterval barAnimationDuration;
/** bar隐藏动画时长  默认.27f */
@property (assign, nonatomic) NSTimeInterval fadeAnimationDuration;
/** bar隐藏时间间隔  .1f*/
@property (assign, nonatomic) NSTimeInterval fadeOutDelay;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
