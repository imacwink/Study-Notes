//
//  ViewController.m
//  ios-lighting
//
//  Created by 王云刚 on 2020/4/22.
//  Copyright © 2020 王云刚. All rights reserved.
//

#import "ViewController.h"
#import "GL3DViewColor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect glViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    EAGLContext* eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GL3DViewColor *gl3DViewColor = [[GL3DViewColor alloc] initWithFrame:glViewFrame context:eaglContext];
    [self.view addSubview:gl3DViewColor];
}


@end
