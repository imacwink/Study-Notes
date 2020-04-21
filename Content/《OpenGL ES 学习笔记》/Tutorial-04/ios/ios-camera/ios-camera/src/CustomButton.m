//
//  CustomButton.m
//  ios-camera
//
//  Created by 王云刚 on 2020/4/21.
//  Copyright © 2020 王云刚. All rights reserved.
//

#import "CustomButton.h"

@interface CustomButton() {
    CADisplayLink * _displaylinkTimer;
}

@end

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)content{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * title = [[UILabel alloc] initWithFrame:self.bounds];
        title.text = content;
        title.textColor = [UIColor blackColor];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
    }
    return self;
}

- (void)createCADisplayLink { // 创建定时器;
    _displaylinkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [_displaylinkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)invalidateCADisplayLink { // 销毁定时器;
    [_displaylinkTimer invalidate];
    _displaylinkTimer = nil;
}

- (void)handleDisplayLink:(CADisplayLink *)displaylinkTimer{
    if([self.delegate respondsToSelector:@selector(onTouchedLongTime:)]) {
        [self.delegate onTouchedLongTime:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self createCADisplayLink];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self invalidateCADisplayLink];
}

@end
