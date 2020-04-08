//
//  ViewController.m
//  ios-glkit
//
//  Created by 王云刚 on 2020/4/4.
//  Copyright © 2020 王云刚. All rights reserved.
//
//
//                 .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//             __.'              ~.   .~              `.__
//           .'//                  \./                  \\`.
//         .'//                     |                     \\`.
//       .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//     .'//.-"                 `-.  |  .-'                 "-.\\`.
//   .'//______.============-..   \ | /   ..-============.______\\`.
// .'______________________________\|/______________________________`.
//

#import "ViewController.h"
#import "GLView.h"
#import "GLView_Rotation.h"
#import "GLView_Scale.h"
#import "GLView_Postion.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CGRect frame0 = CGRectMake(0, 100, self.view.frame.size.width, 80);
    CGRect frame1 = CGRectMake(0, 190, self.view.frame.size.width, 80);
    CGRect frame2 = CGRectMake(0, 280, self.view.frame.size.width, 80);
    CGRect frame3 = CGRectMake(0, 370, self.view.frame.size.width, 80);
    
    [self createButton:@"GLView" tag:2000 frame:frame0];
    [self createButton:@"GLView_Rotation" tag:2001 frame:frame1];
    [self createButton:@"GLView_Scale" tag:2002 frame:frame2];
    [self createButton:@"GLView_Postion" tag:2003 frame:frame3];
}

- (void)createButton:(NSString *)strTitle tag:(NSInteger)iTag frame:(CGRect)rect {
    // 创建按钮（UIButton）;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = rect;
    button.tag = iTag;

    // 设置按钮上显示的文字;
    [button setTitle:strTitle forState:UIControlStateNormal];
    [button setTitle:strTitle forState:UIControlStateHighlighted];

    // 通过代码为控件注册一个单机事件;
    [button addTarget:self action:@selector(buttonPrint:) forControlEvents:UIControlEventTouchUpInside];

    // 把动态创建的控件添加到控制器的view中;
    [self.view addSubview:button];
}

- (void)buttonPrint:(UIButton *)sender {
    CGRect glViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    EAGLContext* eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    switch (sender.tag) {
        case 2000:
        {
            GLView *glView = [[GLView alloc] initWithFrame:glViewFrame context:eaglContext];
            [self.view addSubview:glView];
        }
            break;
        case 2001:
        {
            GLView_Rotation *glView_Rotation = [[GLView_Rotation alloc] initWithFrame:glViewFrame context:eaglContext];
            [self.view addSubview:glView_Rotation];
        }
            break;
        case 2002:
        {
            GLView_Scale *glView_Scale = [[GLView_Scale alloc] initWithFrame:glViewFrame context:eaglContext];
            [self.view addSubview:glView_Scale];
        }
            break;
        case 2003:
        {
            GLView_Postion *glView_Postion = [[GLView_Postion alloc] initWithFrame:glViewFrame context:eaglContext];
            [self.view addSubview:glView_Postion];
        }
            break;
        default:
            break;
    }
}

@end

