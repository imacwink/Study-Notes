//
//  GL3DView_Rotation.m
//  ios-mvp
//
//  Created by 王云刚 on 2020/4/11.
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

#import "GL3DView_Rotation.h"
#import <GLKit/GLKit.h>
#import "GLESUtils.h"
#import "GLESMath.h"

#define DEBUG 1 // 便于调试添加 DEBUG;

// 顶点数据结构;
typedef struct {
    GLKVector3 positionCoords; // 顶点坐标;
    GLKVector3 vertexAttribColor; // 顶点颜色;
    GLKVector2 textureCoords; // 纹理坐标;
} VertexStruct;

static const VertexStruct vertices[] = {
    // X轴0.5处的平面;
    {{0.5f,   -0.5f,   0.5f}, {1,  0,  0}, {0, 0}},
    {{0.5f,   -0.5f,  -0.5f}, {1,  0,  0}, {0, 1}},
    {{0.5f,   0.5f,   -0.5f}, {1,  0,  0}, {1, 1}},
    {{0.5f,   0.5f,   -0.5f}, {1,  0,  0}, {1, 1}},
    {{0.5f,   0.5f,    0.5f}, {1,  0,  0}, {1, 0}},
    {{0.5f,   -0.5f,   0.5f}, {1,  0,  0}, {0, 0}},

    // X轴-0.5处的平面;
    {{-0.5f,  0.5f,   -0.5f}, {-1,  0,  0}, {1, 1}},
    {{-0.5f,  -0.5f,  -0.5f}, {-1,  0,  0}, {0, 1}},
    {{-0.5f,  -0.5f,   0.5f}, {-1,  0,  0}, {0, 0}},
    {{-0.5f,  -0.5f,   0.5f}, {-1,  0,  0}, {0, 0}},
    {{-0.5f,  0.5f,    0.5f}, {-1,  0,  0}, {1, 0}},
    {{-0.5f,  0.5f,   -0.5f}, {-1,  0,  0}, {1, 1}},

    // Y轴0.5处的平面;
    {{0.5f,   0.5f,   -0.5f}, {0,  1,  0}, {1, 1}},
    {{-0.5f,  0.5f,   -0.5f}, {0,  1,  0}, {0, 1}},
    {{-0.5f,  0.5f,   0.5f}, {0,  1,  0}, {0, 0}},
    {{-0.5f,  0.5f,   0.5f}, {0,  1,  0}, {0, 0}},
    {{0.5f,   0.5f,   0.5f}, {0,  1,  0}, {1, 0}},
    {{0.5f,   0.5f,   -0.5f}, {0,  1,  0}, {1, 1}},

    // Y轴-0.5处的平面;
    {{-0.5f,  -0.5f,  0.5f}, {0,  -1,  0}, {0, 0}},
    {{-0.5f,  -0.5f,  -0.5f}, {0,  -1,  0}, {0, 1}},
    {{0.5f,   -0.5f,  -0.5f}, {0,  -1,  0}, {1, 1}},
    {{0.5f,   -0.5f,  -0.5f}, {0,  -1,  0}, {1, 1}},
    {{0.5f,   -0.5f,  0.5f}, {0,  -1,  0}, {1, 0}},
    {{-0.5f,  -0.5f,  0.5f}, {0,  -1,  0}, {0, 0}},
    
    // Z轴0.5处的平面;
    {{-0.5f,   0.5f,  0.5f},  {0,  0,  1}, {0, 0}},
    {{-0.5f,  -0.5f,  0.5f},  {0,  0,  1}, {0, 1}},
    {{0.5f,   -0.5f,  0.5f},  {0,  0,  1}, {1, 1}},
    {{0.5f,   -0.5f,  0.5f},  {0,  0,  1}, {1, 1}},
    {{0.5f,   0.5f,   0.5f},  {0,  0,  1}, {1, 0}},
    {{-0.5f,  0.5f,   0.5f},  {0,  0,  1}, {0, 0}},

    // Z轴-0.5处的平面;
    {{0.5f,   -0.5f,  -0.5f}, {0,  0,  -1}, {1, 1}},
    {{-0.5f,  -0.5f,  -0.5f}, {0,  0,  -1}, {0, 1}},
    {{-0.5f,  0.5f,   -0.5f}, {0,  0,  -1}, {0, 0}},
    {{-0.5f,  0.5f,   -0.5f}, {0,  0,  -1}, {0, 0}},
    {{0.5f,   0.5f,   -0.5f}, {0,  0,  -1}, {1, 0}},
    {{0.5f,   -0.5f,  -0.5f},  {0,  0,  -1}, {1, 1}},
};

@interface GL3DView_Rotation()

@property(nonatomic, strong) EAGLContext *eaglContext;
@property (nonatomic, strong) CAEAGLLayer *eaglLayer;
@property (nonatomic, assign) GLuint displayProgram;
@property (nonatomic , assign) GLuint colorRenderBuffer;
@property (nonatomic , assign) GLuint colorFrameBuffer;

@property (nonatomic , assign) float fX;
@property (nonatomic , assign) float fY;
@property (nonatomic , assign) float fZ;
@property (nonatomic , assign) float fov;

@end

@implementation GL3DView_Rotation

+ (Class)layerClass {
    return [CAEAGLLayer class]; /*只有 [CAEAGLLayer class] 类型的 layer 才支持在其上描绘 OpenGL 内容*/
}

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置渲染需要的 Layer;
        [self setupLayer];
        
        // 设置渲染环境;
        [self setupContext:context];
        
        // 删除 Color Buffer;
        [self deleteColorFrameBuffer];
        [self deleteColorRenderBuffer];
        
        // 创建和绑定 Color Buffer;
        [self bindColorRenderBuffer];
        [self bindColorFrameBuffer];
        
        // Shader 处理;
        [self loadShaders];
        
        // VBO处理;
        [self fillVBO];

        // 纹理处理;
        [self fillTexture:@"for-test-001.jpeg"];
        
        // 绘制：默认旋转 0 度;
        self.fov = 25.0f;
        [self processRender:0 y:0 z:0 fov:25.0f];
        
        // 创建调试 UI;
        [self createSliders];
    }
    return self;
}

#pragma mark - Base Debug UI
- (void)createSliders {
    CGRect xRect = CGRectMake(40, self.frame.size.height - 250, 295, 30);
    CGRect yRect = CGRectMake(40, self.frame.size.height - 200, 295, 30);
    CGRect zRect = CGRectMake(40, self.frame.size.height - 150, 295, 30);
    CGRect fovRect = CGRectMake(40, self.frame.size.height - 100, 295, 30);
    [self sliderView:xRect tag:1000];
    [self sliderView:yRect tag:1001];
    [self sliderView:zRect tag:1002];
    [self sliderView:fovRect tag:1003];
}

- (void)sliderView:(CGRect)rect tag:(NSInteger)iTag {
    // 创建描述标签;
    UILabel * uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x - 20, rect.origin.y, 40, 30)];
    UILabel * uiLabelDes = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + 295 + 10, rect.origin.y, 80, 30)];
    uiLabel.textColor = [UIColor whiteColor];
    uiLabelDes.textColor = [UIColor whiteColor];
    uiLabelDes.tag = iTag + 100;
    if (1000 == iTag) {
        uiLabel.text = @"X";
        uiLabelDes.text = @"0";
    } else if (1001 == iTag) {
        uiLabel.text = @"Y";
        uiLabelDes.text = @"0";
    } else if (1002 == iTag) {
        uiLabel.text = @"Z";
        uiLabelDes.text = @"0";
    } else if (1003 == iTag) {
        uiLabel.text = @"fov";
        uiLabelDes.text = @"25";
    }
    [self addSubview:uiLabel];
    [self addSubview:uiLabelDes];
    
    // 实例化UISlider，高度对外观没有影响;
    UISlider * uiSlider = [[UISlider alloc] initWithFrame:rect];
    uiSlider.tag = iTag;
      
    if (1003 == iTag) {
        // 设置Slider的最大值和最小值;
        uiSlider.maximumValue = 180;
        uiSlider.minimumValue = 0;
        
        // 设置Slider的值，thumb会跳到对应的位置;
        uiSlider.value = 25;
    } else {
        // 设置Slider的最大值和最小值;
        uiSlider.maximumValue = 180;
        uiSlider.minimumValue = -180;
        
        // 设置Slider的值，thumb会跳到对应的位置;
        uiSlider.value = 0;
    }
    
    // 添加Slider滑动事件;
    [uiSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
     
    // 把Slider添加到view上;
    [self addSubview:uiSlider];
}

- (void)sliderValueChanged:(UISlider *)slider {
    UILabel *uiLabel = (UILabel *)[self viewWithTag:(slider.tag + 100)];
    NSString *myString = [NSString stringWithFormat:@"%.2f", slider.value];
    uiLabel.text = myString;
    
    if (1000 == slider.tag) {
        self.fX = slider.value;
    } else if (1001 == slider.tag) {
        self.fY = slider.value;
    } else if (1002 == slider.tag) {
        self.fZ = slider.value;
    } else if (1003 == slider.tag) {
        self.fov = slider.value;
    }
    
    [self processRender:self.fX y:self.fY z:self.fZ fov:self.fov];
}

#pragma mark - Setup GLView
- (void)setupLayer {
    self.eaglLayer = (CAEAGLLayer *)self.layer;
    self.eaglLayer.opaque = YES; /*CALayer 默认是透明的，必须将它设为不透明才能让其可见*/
    self.eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:NO],
                                    kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGBA8, /*设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8*/
                                    kEAGLDrawablePropertyColorFormat,
                                    nil];
}

- (void)setupContext:(EAGLContext *)context {
     self.eaglContext = context; /*设置上下文信息*/
    
    if (!self.eaglContext) {
        NSLog(@"eaglContext is nil !");
    }
    
    if ([EAGLContext currentContext] != self.eaglContext) {
        if (![EAGLContext setCurrentContext:self.eaglContext]) {
            NSLog(@"failure set eaglContext !");
        }
    }
}

- (void)deleteColorRenderBuffer {
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    self.colorRenderBuffer = 0;
}

- (void)deleteColorFrameBuffer {
    glDeleteFramebuffers(1, &_colorFrameBuffer);
    self.colorFrameBuffer = 0;
}

- (void)bindColorRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, self.colorRenderBuffer);
    [self.eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.eaglLayer];
}

- (void)bindColorFrameBuffer {
    glGenFramebuffers(1, &_colorFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, self.colorFrameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.colorRenderBuffer);
}

- (void)fillVBO {
    GLuint vboID;
    glGenBuffers(1, &vboID);
    glBindBuffer(GL_ARRAY_BUFFER, vboID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    
    GLuint position = glGetAttribLocation(self.displayProgram, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), NULL + offsetof(VertexStruct, positionCoords));
    glEnableVertexAttribArray(position);

    GLuint textCoordinate = glGetAttribLocation(self.displayProgram, "textureCoordinate");
    glVertexAttribPointer(textCoordinate, 2, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), NULL + offsetof(VertexStruct, textureCoords));
    glEnableVertexAttribArray(textCoordinate);
}

- (GLuint)fillTexture:(NSString *)fileName {
    // 获取图片的 CGImageRef;
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 读取图片的大小;
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); // rgba共4个byte;
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData,
                                                       width,
                                                       height,
                                                       8,
                                                       width * 4,
                                                       CGImageGetColorSpace(spriteImage),
                                                       kCGImageAlphaPremultipliedLast);
    
    // 在 CGContextRef 上绘图;
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    
    // 开启渲染纹理;
    glEnable(GL_TEXTURE_2D);
    
    /**
     * GL_TEXTURE_2D 表示操作 2D 纹理
     * 初始化纹理对象：GLuint textureID;
     * 创建纹理对象： glGenTextures(1, &textureID);
     * 绑定纹理对象：glBindTexture(GL_TEXTURE_2D, textureID);
     * 这里比较特殊，我们使用默认的纹理ID（因为这里只有一张图片，相当于片元着色器里面的 colorMap，如果有多张图需要自己手动添加 sampler2D，同时要走纹理ID创建的流程）;
     */
    glBindTexture(GL_TEXTURE_2D, 0);
    
    /**
      *  纹理过滤函数
      *  图象从纹理图象空间映射到帧缓冲图象空间(映射需要重新构造纹理图像,这样就会造成应用到多边形上的图像失真),
      *  这时就可用glTexParmeteri()函数来确定如何把纹理象素映射成像素.
      *  如何把图像从纹理图像空间映射到帧缓冲图像空间（即如何把纹理像素映射成像素）
      */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);  // S方向上的贴图模式;
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);  // T方向上 的贴图模式;

    // 线性过滤：使用距离当前渲染像素中心最近的4个纹理像素加权平均值;
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    /**
     *  将图像数据传递给到 GL_TEXTURE_2D 中, 因其于 textureID 纹理对象已经绑定，所以即传递给了 textureID 纹理对象中。
     *  glTexImage2d会将图像数据从CPU内存通过PCIE上传到GPU内存。
     *  不使用PBO时它是一个阻塞CPU的函数，数据量大会卡。
     */
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glBindTexture(GL_TEXTURE_2D, 0); // 解绑定;
    free(spriteData);
    
    return 0;
}

#pragma mark - Process Shader
- (void)loadShaders {
    NSString *vertShaderFile = [[NSBundle mainBundle] pathForResource:@"display-rotation-3d" ofType:@"vsh"];
    NSString *fragShaderFile = [[NSBundle mainBundle] pathForResource:@"display-rotation-3d" ofType:@"fsh"];
    self.displayProgram = [GLESUtils loadProgram:vertShaderFile withFragmentShaderFilepath:fragShaderFile];
}

#pragma mark - Process Render
- (void)processRender:(float)fX y:(float)fY z:(float)fZ fov:(float)fovz {
    glClearColor(0, 0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    float width = self.frame.size.width * scale;
    float height = self.frame.size.height * scale;
    GLint originX = self.frame.origin.x * scale;
    GLint originY = self.frame.origin.y * scale;
    glViewport(originX, originY, width, height); // 设置视口大小(这里实际的像素尺寸大小);
    
    glUseProgram(self.displayProgram); // 链接成功才能使用;
    
    glEnable(GL_CULL_FACE);
    
    [self setPerspectiveProjectionMatrix:fovz at:(width/height) nZ:5.0f fZ:20.0f]; // 设置投影矩阵;
//    [self setOrthoProjectionMatrix:-20.0 r:20.0f b:-20.0f t:-20.0f nZ:0.0f fZ:1000.0f]; // 设置正交矩阵;
    
    [self processRotation:fX y:fY z:fZ]; // 处理旋转;
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices) / sizeof(VertexStruct)); // DC;
    
    // 将指定 renderbuffer 呈现在屏幕上，在 renderbuffer 被呈现之前，首先调用 renderbufferStorage:fromDrawable: 为之分配存储空间;
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setPerspectiveProjectionMatrix:(float)fovy at:(float)aspect  nZ:(float)nearZ  fZ:(float)farZ {
    GLuint projectionMatrixSlot = glGetUniformLocation(self.displayProgram, "projectionMatrix");
    
    KSMatrix4 projectionMatrix;
    ksMatrixLoadIdentity(&projectionMatrix);
    ksPerspective(&projectionMatrix, fovy, aspect, nearZ, farZ);
    glUniformMatrix4fv(projectionMatrixSlot, 1, GL_FALSE, (GLfloat*)&projectionMatrix.m[0][0]);
}

- (void)setOrthoProjectionMatrix:(float)left r:(float)right b:(float)bottom t:(float)top nZ:(float)nearZ fZ:(float)farZ {
    GLuint projectionMatrixSlot = glGetUniformLocation(self.displayProgram, "projectionMatrix");
        
    KSMatrix4 projectionMatrix;
    ksMatrixLoadIdentity(&projectionMatrix);
    ksOrtho(&projectionMatrix, left, right, bottom, top, nearZ, farZ);
    glUniformMatrix4fv(projectionMatrixSlot, 1, GL_FALSE, (GLfloat*)&projectionMatrix.m[0][0]);
}

- (void)processRotation:(float)fX y:(float)fY z:(float)fZ {
    GLuint modelViewMatrixSlot = glGetUniformLocation(self.displayProgram, "modelViewMatrix");
    KSMatrix4 modelViewMatrix;
    ksMatrixLoadIdentity(&modelViewMatrix);
        
    // 平移(请思考这里为什么要做Z轴平移);
    ksTranslate(&modelViewMatrix, 0.0, 0.0, -10.0);
    
    KSMatrix4 rotationMatrix;
    ksMatrixLoadIdentity(&rotationMatrix);
        
    // 旋转;
    ksRotate(&rotationMatrix, fX, 1.0, 0.0, 0.0); // 绕X轴;
    ksRotate(&rotationMatrix, fY, 0.0, 1.0, 0.0); // 绕Y轴;
    ksRotate(&rotationMatrix, fZ, 0.0, 0.0, 1.0); // 绕Z轴;
        
    // 把变换矩阵相乘，左乘;
    ksMatrixMultiply(&modelViewMatrix, &rotationMatrix, &modelViewMatrix);
    
    glUniformMatrix4fv(modelViewMatrixSlot, 1, GL_FALSE, (GLfloat*)&modelViewMatrix.m[0][0]);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end

