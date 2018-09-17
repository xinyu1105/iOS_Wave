//
//  TieBarLoadingView.h
//  TieBaLoadingAnimation
//
//  Created by pengjiaxin on 2018/9/13.
//  Copyright © 2018年 pengjiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TieBarLoadingView : UIView

-(void)show;

-(void)hide;

/**
 显示方法

 @param view view description
 */
+(void)showInView:(UIView *)view;


/**
 隐藏方法

 @param view view description
 */
+(void)hideInView:(UIView *)view;












@end
