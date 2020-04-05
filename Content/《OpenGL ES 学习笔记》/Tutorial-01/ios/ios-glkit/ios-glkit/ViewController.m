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
#import <GLKit/GLKit.h>
#import <GLKit/GLKView.h>

// 顶点数据结构;
typedef struct {
    GLKVector3 positionCoords; // 顶点坐标;
    GLKVector2 textureCoords; // 纹理坐标;
} VertexStruct;

// 内容是顶点数据，前三个是顶点坐标（x、y、z）坐标范围（-1，1），后两个是纹理坐标（x，y）坐标范围（0，1）;
static const VertexStruct vertices[] = {
    // 右上三角形;
    {{1.0, -1.0, 0.0f,}, {1.0f, 0.0f}}, // 右下;
    {{1.0, 1.0,  0.0f}, {1.0f, 1.0f}}, // 右上;
    {{-1.0, 1.0, 0.0f}, {0.0f, 1.0f}}, // 左上;

    // 左下三角形;
    {{1.0, -1.0, 0.0f}, {1.0f, 0.0f}}, // 右下;
    {{-1.0, 1.0, 0.0f}, {0.0f, 1.0f}}, // 左上;
    {{-1.0, -1.0, 0.0f}, {0.0f, 0.0f}}, // 左下;
};

// 指定顶点属性数据 顶点位置 纹理坐标;
static const VertexStruct vertices_for_indices[] = {
    {{-1.0, -1.0, 0.0f}, {0.0f, 0.0f}}, // 左下-0;
    {{1.0, -1.0, 0.0f}, {1.0f, 0.0f}},  // 右下-1;
    {{-1.0, 1.0, 0.0f}, {0.0f, 1.0f}},  // 左上-2;
    {{1.0, 1.0,  0.0f}, {1.0f, 1.0f}},  // 右上-3;
};

// 索引数据;
GLshort indices[] = {
    0, 1, 2,  // 0;
    2, 1, 3   // 1;
};

// 指定顶点属性数据 顶点位置 纹理坐标（建议UV分别存储，为了方便测试放在一起，导致存在冗余映射）;
static const VertexStruct vertices_for_indices1[] = {
    {{-1.0, -1.0, 0.0f}, {0.0f, 0.0f}}, // 0;
    {{0.0, -1.0, 0.0f}, {1.0f, 0.0f}},  // 1;
    {{-1.0, 1.0, 0.0f}, {0.0f, 1.0f}},  // 2;
    {{0.0, 1.0, 0.0f}, {1.0f, 1.0f}},   // 3;
    
    {{0.0, -1.0, 0.0f}, {0.0f, 0.0f}},  // 4;
    {{1.0, -1.0, 0.0f}, {1.0f, 0.0f}},  // 5;
    {{0.0, 1.0, 0.0f}, {0.0f, 1.0f}},   // 6;
    {{1.0, 1.0, 0.0f}, {1.0f, 1.0f}},   // 7;
};

// 索引数据;
GLshort indices1[] = {
    0, 1, 2,   // 0;
    2, 1, 3,   // 1;
    4, 5, 6,   // 2;
    6, 5, 7,   // 3;
};

@interface ViewController () <GLKViewDelegate>

@property(nonatomic, retain) EAGLContext *eaglContext;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 新建OpenGLES 上下文;
    self.eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; // 采用兼容性更好的2.0版本；
    
    // 新建GLKView;
    CGRect glkViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    GLKView *glkView = [[GLKView alloc] initWithFrame:glkViewFrame context:self.eaglContext];
    glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  // 颜色缓冲区格式;
    glkView.delegate = self; // 设置代理，处理 glkView 回调函数;
    
    // 设置当前上下文;
    [EAGLContext setCurrentContext:self.eaglContext];
    
    // 填充纹理;
    [self fillTexture];
    
    // 顶点数据缓存;
    [self fillVertexArray];
    
    [self.view addSubview:glkView];
}

- (void)fillVertexArray { // 顶点数据缓存;
    // Step0: 创建缓存对象;
    GLuint vboId, eboId;
    
//    // Step1: 创建并绑定VBO 对象 传送数据;
//    glGenBuffers(1, &vboId);
//    glBindBuffer(GL_ARRAY_BUFFER, vboId); // 绑定指定标识符的缓存为当前缓存;
//    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
//
//    // Step2: 指定解析方式  并启用顶点属性&纹理坐标属性;
//    glEnableVertexAttribArray(GLKVertexAttribPosition); // 顶点数据缓存;
//    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), NULL + offsetof(VertexStruct, positionCoords));
//    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); // 纹理;
//    glVertexAttribPointer(GLKVertexAttribTexCoord0, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), NULL + offsetof(VertexStruct, textureCoords));
    
    // Step1: 创建并绑定VBO 对象 传送数据;
    glGenBuffers(1, &vboId);
    glBindBuffer(GL_ARRAY_BUFFER, vboId);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices_for_indices1), vertices_for_indices1, GL_STATIC_DRAW);

    // Step2: 创建并绑定EBO 对象 传送数据;
    glGenBuffers(1, &eboId);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, eboId);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices1), indices1, GL_STATIC_DRAW);

    // Step3: 指定解析方式  并启用顶点属性;
    // 顶点位置属性;
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), NULL + offsetof(VertexStruct, positionCoords));

    // 纹理坐标属性;
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), NULL + offsetof(VertexStruct, textureCoords));

    // 解除VBO绑定;
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)fillTexture { // 填充纹理数据;
    // 纹理贴图;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"for-test-001" ofType:@"jpeg"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil]; // GLKTextureLoaderOriginBottomLeft 纹理坐标系是反的;
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    // 着色器;
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    self.baseEffect.texture2d0.name = textureInfo.name;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 清除背景色;
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self.baseEffect prepareToDraw];
//    glDrawArrays(GL_TRIANGLES, 0, 6);
    glDrawElements(GL_TRIANGLES, 12, GL_UNSIGNED_SHORT, 0);
}

@end
