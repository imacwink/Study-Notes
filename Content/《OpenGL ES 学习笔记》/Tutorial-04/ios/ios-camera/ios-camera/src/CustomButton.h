//
//  CustomButton.h
//  ios-camera
//
//  Created by 王云刚 on 2020/4/21.
//  Copyright © 2020 王云刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomButtonDelegate <NSObject>

@optional

- (void)onTouchedLongTime:(UIView *)view;

@end

@interface CustomButton : UIView

@property (weak, nonatomic) id<CustomButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
