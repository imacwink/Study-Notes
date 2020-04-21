//
//  ViewController.m
//  ios-camera
//
//  Created by 王云刚 on 2020/4/17.
//  Copyright © 2020 王云刚. All rights reserved.
//

#import "ViewController.h"
#import "GL3DView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect glViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    EAGLContext* eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GL3DView *gl3DView = [[GL3DView alloc] initWithFrame:glViewFrame context:eaglContext];
    [self.view addSubview:gl3DView];
}


@end
