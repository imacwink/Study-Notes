//
//  GLView.h
//  ios-shader
//
//  Created by 王云刚 on 2020/4/5.
//  Copyright © 2020 王云刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLView : UIView

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context;

@end

NS_ASSUME_NONNULL_END
