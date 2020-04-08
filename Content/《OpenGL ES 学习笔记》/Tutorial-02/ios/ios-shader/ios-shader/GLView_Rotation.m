//
//  GLView-Rotation.m
//  ios-shader
//
//  Created by 王云刚 on 2020/4/7.
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

#import "GLView_Rotation.h"
#import <GLKit/GLKit.h>

#define DEBUG 1 // 便于调试添加 DEBUG;

// 顶点数据结构;
typedef struct {
    GLKVector3 positionCoords; // 顶点坐标;
    GLKVector3 textureCoords; // 纹理坐标;
} VertexStruct;

// 内容是顶点数据，前三个是顶点坐标（x、y、z）坐标范围（-1，1），后两个是纹理坐标（x，y，z）坐标范围（0，1）;
static const VertexStruct vertices[] = {
    // 右上三角形;
    {{0.5, -0.5, 0.0f,}, {1.0f, 0.0f, 0.0f}}, // 右下;
    {{0.5, 0.5, 0.0f}, {1.0f, 1.0f, 0.0f}}, // 右上;
    {{-0.5, 0.5, 0.0f}, {0.0f, 1.0, 0.0f}}, // 左上;

    // 左下三角形;
    {{0.5, -0.5, 0.0f}, {1.0f, 0.0f, 0.0f}}, // 右下;
    {{-0.5, 0.5, 0.0f}, {0.0f, 1.0f, 0.0f}}, // 左上;
    {{-0.5, -0.5, 0.0f}, {0.0f, 0.0f, 0.0f}}, // 左下;
};

@interface GLView_Rotation()

@property(nonatomic, strong) EAGLContext *eaglContext;
@property (nonatomic, strong) CAEAGLLayer *eaglLayer;
@property (nonatomic, assign) GLuint displayProgram;
@property (nonatomic , assign) GLuint colorRenderBuffer;
@property (nonatomic , assign) GLuint colorFrameBuffer;

@property (nonatomic , assign) float fX;
@property (nonatomic , assign) float fY;
@property (nonatomic , assign) float fZ;

@property (nonatomic , assign) NSInteger tempTag;

@end

@implementation GLView_Rotation

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
        [self processRender:0 y:0 z:0];
        
        // 创建调试 UI;
        [self createSliders];
    }
    return self;
}

#pragma mark - Base Debug UI
- (void)createSliders {
    CGRect xRect = CGRectMake(40, self.frame.size.height - 200, 295, 30);
    CGRect yRect = CGRectMake(40, self.frame.size.height - 150, 295, 30);
    CGRect zRect = CGRectMake(40, self.frame.size.height - 100, 295, 30);
    [self sliderView:xRect tag:1000];
    [self sliderView:yRect tag:1001];
    [self sliderView:zRect tag:1002];
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
    }
    [self addSubview:uiLabel];
    [self addSubview:uiLabelDes];
    
    // 实例化UISlider，高度对外观没有影响;
    UISlider * uiSlider = [[UISlider alloc] initWithFrame:rect];
    uiSlider.tag = iTag;
      
    // 设置Slider的最大值和最小值;
    uiSlider.maximumValue = 180;
    uiSlider.minimumValue = -180;
    
    // 设置Slider的值，thumb会跳到对应的位置;
    uiSlider.value = 0;
    
    // 添加Slider滑动事件;
    [uiSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
     
    // 把Slider添加到view上;
    [self addSubview:uiSlider];
}

- (void)sliderValueChanged:(UISlider *)slider {
    UILabel *uiLabel = (UILabel *)[self viewWithTag:(slider.tag + 100)];
    NSString *myString = [NSString stringWithFormat:@"%.2f", slider.value];
    uiLabel.text = myString;
    
    self.tempTag = slider.tag;
    
    if (1000 == slider.tag) {
        self.fX = slider.value;
    } else if (1001 == slider.tag) {
        self.fY = slider.value;
    } else if (1002 == slider.tag) {
        self.fZ = slider.value;
    }
    
    [self processRender:self.fX y:self.fY z:self.fZ];
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
    glVertexAttribPointer(textCoordinate, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), NULL + offsetof(VertexStruct, textureCoords));
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
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );  // S方向上的贴图模式;
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );  // T方向上 的贴图模式;
    
    // 线性过滤：使用距离当前渲染像素中心最近的4个纹理像素加权平均值;
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    
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
    // 读取 Shader 文件路径;
    NSString *vertShaderFile = [[NSBundle mainBundle] pathForResource:@"display-rotation" ofType:@"vsh"];
    NSString *fragShaderFile = [[NSBundle mainBundle] pathForResource:@"display-rotation" ofType:@"fsh"];
    
    // 编译;
    self.displayProgram = [self processShaders:vertShaderFile frag:fragShaderFile];
    
    // 链接;
    [self linkProgram:self.displayProgram];
}

- (GLuint)processShaders:(NSString *)vertShaderFile frag:(NSString *)fragShaderFile {
    GLuint vertShader, fragShader;
    GLint program = glCreateProgram();
    
    // 编译 Shader;
    [self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderFile];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderFile];
    
    // 添加 Shader 到容器;
    glAttachShader(program, vertShader);
    glAttachShader(program, fragShader);
    
    // 释放 Shader;
    glDeleteShader(vertShader);
    glDeleteShader(fragShader);
    
    return program;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)shaderFile {
    // 获取文件的内容并进行 NSUTF8StringEncoding 编码;
    const GLchar *source;
    source = (GLchar *)[[NSString stringWithContentsOfFile:shaderFile encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    // 根据类型创建着色器;
    *shader = glCreateShader(type);
    
    // 获取着色器的数据源;
    glShaderSource(*shader, 1, &source, NULL);
    
    // 开始编译;
    glCompileShader(*shader);
    
    // 方便调试，可以不用;
    #if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
    #endif
    
    // 查看是否编译成功;
    GLint status;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog {
    // 链接程序;
    glLinkProgram(prog);
        
    #if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
    #endif
    
    // 检查链接结果;
    GLint status;
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - Process Render
- (void)processRender:(float)fX y:(float)fY z:(float)fZ {
    glClearColor(0, 0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CGFloat scale = [[UIScreen mainScreen] scale]; // 获取视图放大倍数，可以把scale设置为1试试;
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); // 设置视口大小;
    
    glUseProgram(self.displayProgram); // 链接成功才能使用;
    
    if (1000 == self.tempTag) {
        [self processRotationX:fX];
    } else if (1001 == self.tempTag){
        [self processRotationY:fY];
    } else if (1002 == self.tempTag){
        [self processRotationZ:fZ];
    } else {
        [self processRotationZ:0];
    }

    glDrawArrays(GL_TRIANGLES, 0, 6); // DC;
    
    // 将指定 renderbuffer 呈现在屏幕上，在 renderbuffer 被呈现之前，首先调用 renderbufferStorage:fromDrawable: 为之分配存储空间;
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)processRotationX:(float)fX {
      GLuint rotate = glGetUniformLocation(self.displayProgram, "rotateMatrix"); /*获取Shader里面的旋转矩阵*/

        float radiansX = fX * 3.14159f / 180.0f;
        float sinaX = sin(radiansX);
        float cosaX = cos(radiansX);

        // X 轴旋转矩阵;
        GLfloat xRotateMatrix[16] = { //
            1.0, 0.0, 0.0, 0.0, //
            0.0, cosaX, sinaX, 0.0,//
            0.0, -sinaX, cosaX, 0.0,//
            0.0, 0.0, 0.0, 1.0//
        };

        // 设置旋转矩阵;
        glUniformMatrix4fv(rotate, 1, GL_FALSE, (GLfloat *)&xRotateMatrix[0]);
}

- (void)processRotationY:(float)fY {
        GLuint rotate = glGetUniformLocation(self.displayProgram, "rotateMatrix"); /*获取Shader里面的旋转矩阵*/
        
        float radiansY = fY * 3.14159f / 180.0f;
        float sinaY = sin(radiansY);
        float cosaY = cos(radiansY);

        // Z 轴旋转矩阵;
        GLfloat zRotateMatrix[16] = { //
            cosaY, 0.0, sinaY, 0.0, //
            0.0, 1.0, 0.0, 0.0,//
            -sinaY, 0.0, cosaY, 0.0,//
            0.0, 0.0, 0.0, 1.0//
        };
    
        // 设置旋转矩阵;
        glUniformMatrix4fv(rotate, 1, GL_FALSE, (GLfloat *)&zRotateMatrix[0]);
}

- (void)processRotationZ:(float)fZ {
        GLuint rotate = glGetUniformLocation(self.displayProgram, "rotateMatrix"); /*获取Shader里面的旋转矩阵*/
        
        float radiansZ = fZ * 3.14159f / 180.0f;
        float sinaZ = sin(radiansZ);
        float cosaZ = cos(radiansZ);

        // Z 轴旋转矩阵;
        GLfloat zRotateMatrix[16] = { //
            cosaZ, sinaZ, 0.0, 0.0, //
            -sinaZ, cosaZ, 0.0, 0.0,//
            0.0, 0.0, 1.0, 0.0,//
            0.0, 0.0, 0.0, 1.0//
        };
    
        // 设置旋转矩阵;
        glUniformMatrix4fv(rotate, 1, GL_FALSE, (GLfloat *)&zRotateMatrix[0]);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
