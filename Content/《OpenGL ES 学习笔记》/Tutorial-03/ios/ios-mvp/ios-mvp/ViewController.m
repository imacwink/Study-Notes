//
//  ViewController.m
//  ios-mvp
//
//  Created by 王云刚 on 2020/4/9.
//  Copyright © 2020 王云刚. All rights reserved.
//

#import "ViewController.h"
#import "GLView_Rotation.h"
#import "GL3DView_Rotation.h"
#import "gl3DViewColor_Rotation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect glViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    EAGLContext* eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
//    GLView_Rotation *glView_Rotation = [[GLView_Rotation alloc] initWithFrame:glViewFrame context:eaglContext];
//    [self.view addSubview:glView_Rotation];
    
    GL3DView_Rotation *gl3DView_Rotation = [[GL3DView_Rotation alloc] initWithFrame:glViewFrame context:eaglContext];
    [self.view addSubview:gl3DView_Rotation];
    
//    GL3DViewColor_Rotation *gl3DViewColor_Rotation = [[GL3DViewColor_Rotation alloc] initWithFrame:glViewFrame context:eaglContext];
//    [self.view addSubview:gl3DViewColor_Rotation];
}


@end
