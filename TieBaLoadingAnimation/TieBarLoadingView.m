//
//  TieBarLoadingView.m
//  TieBaLoadingAnimation
//
//  Created by pengjiaxin on 2018/9/13.
//  Copyright © 2018年 pengjiaxin. All rights reserved.
//

#import "TieBarLoadingView.h"

@interface TieBarLoadingView()
{
    CADisplayLink *_dispalyLink;
    //曲线的振幅
    CGFloat _waveAmplitude;
    //曲线角速度
    CGFloat _wavePalstance;
    //曲线初相
    CGFloat _waveX;
    //曲线偏距
    CGFloat _waveY;
    //曲线移动速度
    CGFloat _waveMoveSpeed;
    //背景发暗的图片 蓝底白字
    UIImageView *_imageView1;
    //前面正常显示的图片 蓝底白字
    UIImageView *_imageView2;
    //动画的容器
    UIView *_containerView;
}
@end

@implementation TieBarLoadingView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self initData];
    }
    return self;
}


-(void)createUI{
    
    //1，画了个圆
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _containerView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _containerView.layer.cornerRadius = _containerView.bounds.size.width/2.0f;
    _containerView.layer.masksToBounds = true;
    [self addSubview:_containerView];
    
    //2，底部图片白底蓝字（第一层）
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_containerView.bounds];
    imageView.image = [UIImage imageNamed:@"1"];
    [_containerView addSubview:imageView];
    
    //3，上层图片蓝底白字（第二层）
    _imageView1 = [[UIImageView alloc] initWithFrame:_containerView.bounds];
    _imageView1.image = [UIImage imageNamed:@"2"];
    //蓝色
    _imageView1.backgroundColor = [UIColor colorWithRed:51/255.0f green:170/255.0f blue:255/255.0f alpha:1];
    [_containerView addSubview:_imageView1];
    
    //4，半透明遮罩（第三层）
    UIView *view = [[UIView alloc] initWithFrame:_imageView1.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [_imageView1 addSubview:view];
    //5，最上层图片蓝底白字（第四层）
    _imageView2 = [[UIImageView alloc] initWithFrame:_containerView.bounds];
    _imageView2.image = [UIImage imageNamed:@"2"];
    _imageView2.backgroundColor = [UIColor colorWithRed:51/255.0f green:170/255.0f blue:255/255.0f alpha:1];
    [_containerView addSubview:_imageView2];
}


/**
 初始化数据
 */
-(void)initData{
    //振幅
    _waveAmplitude = 3;
    //角速度
    _wavePalstance = 0.12;
    //偏距
    _waveY = _containerView.bounds.size.height;
    //初项
    _waveX = 0;
    //x轴移动速度
    _waveMoveSpeed = 0.15;
    //y轴移动速度
   _waveY = _containerView.bounds.size.height/2.0f;
    //以屏幕刷新速度为周期刷新曲线的位置(定时器)
    _dispalyLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
    [_dispalyLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _dispalyLink.paused = true;
}

-(void)updateWave{
   
    //更新x
    _waveX -= _waveMoveSpeed;
    //更新y
    [self updateWave1];
    [self updateWave2];
    
}
-(void)updateWave1{

    //波浪宽度
    CGFloat waterWaveWidth = _containerView.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置点（0，25）左上角
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX + 1) + _waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //填充底部颜色 点(50，50)右下角
    CGPathAddLineToPoint(path, nil, waterWaveWidth, _containerView.bounds.size.height);
    //点(0，50)左下角
    CGPathAddLineToPoint(path, nil, 0, _containerView.bounds.size.height);
    CGPathCloseSubpath(path);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path;
    _imageView1.layer.mask = layer;
    CGPathRelease(path);
    
}
-(void)updateWave2{
    //波浪宽度
    CGFloat waterWaveWidth = _containerView.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置 点（0，25）
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX) + _waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //添加终点路径、填充底部颜色 点（50，50）
    CGPathAddLineToPoint(path, nil, waterWaveWidth, _containerView.bounds.size.height);
    //点（0，50）
    CGPathAddLineToPoint(path, nil, 0, _containerView.bounds.size.height);
    //封闭路径 将路径的终点和起点连接
    CGPathCloseSubpath(path);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path;
    _imageView2.layer.mask = layer;
    //在CG框架中 所有使用到了create函数创建的变量，都需要手动销毁
    CGPathRelease(path);
}

#pragma mark 显示/隐藏方法
-(void)show{
    _dispalyLink.paused = false;
}

-(void)hide{
    _dispalyLink.paused = true;
}

+(void)showInView:(UIView *)view{
    TieBarLoadingView *loadingView = [[TieBarLoadingView alloc]initWithFrame: view.bounds];
    [view addSubview:loadingView];
    [loadingView show];
}

+(void)hideInView:(UIView *)view{
    for (TieBarLoadingView *loadingView in view.subviews) {
        if ([loadingView isKindOfClass:[TieBarLoadingView class]]) {
            [loadingView hide];
            [loadingView removeFromSuperview];
        }
    }
}

-(void)dealloc
{
    if (_dispalyLink) {
        [_dispalyLink invalidate];
        _dispalyLink = nil;
    }
    
    if (_imageView1) {
        [_imageView1 removeFromSuperview];
        _imageView1 = nil;
    }
    if (_imageView2) {
        [_imageView2 removeFromSuperview];
        _imageView2 = nil;
    }
}

//CADisplayLink
//https://www.jianshu.com/p/a96a65093c3b
//https://www.cnblogs.com/oc-bowen/p/6000422.html






















@end
