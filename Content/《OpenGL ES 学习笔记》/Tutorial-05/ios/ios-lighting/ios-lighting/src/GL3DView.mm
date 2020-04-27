 

#import "GL3DView.h"
#import <GLKit/GLKit.h>
#import "GLESUtils.h"
#import <glm/glm.hpp>
#import <glm/gtc/matrix_transform.hpp>
#import <glm/gtc/type_ptr.hpp>
#import "CustomButton.h"

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

@interface GL3DView() <CustomButtonDelegate> {
    glm::vec3 _cameraPos;
    glm::vec3 _cameraFront;
    glm::vec3 _cameraUp;
    GLfloat _deltaTime;   // 当前帧遇上一帧的时间差;
    GLfloat _lastFrame;   // 上一帧的时间;
    CGPoint _originalLocation;
    GLfloat _yaw;
    GLfloat _pitch;
}

@property(nonatomic, strong) EAGLContext *eaglContext;
@property (nonatomic, strong) CAEAGLLayer *eaglLayer;
@property (nonatomic, assign) GLuint displayProgram;
@property (nonatomic , assign) GLuint renderBuffer;
@property (nonatomic , assign) GLuint frameBuffer;
@property (nonatomic , assign) GLuint depthBuffer;

@property (nonatomic , assign) float fov;
@property (nonatomic , assign) float camX;
@property (nonatomic , assign) float camZ;

@end

@implementation GL3DView

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
        
        // 删除 Buffers;
        [self deleteBuffers];
        
        // 创建和绑定 Buffers;
        [self bindBuffers];
        
        // Shader 处理;
        [self loadShaders];
        
        // VBO处理;
        [self fillVBO];

        // 纹理处理;
        [GLESUtils fillTexture:@"for-test-001.jpeg"];
        
        // 初始化参数;
        self.fov = 50.0f;
        _yaw   = -90.0f;
        _pitch =   0.0f;
        
        _cameraPos = glm::vec3(0.0f, 0.0f,  3.0f);
        _cameraFront = glm::vec3(0.0f, 0.0f, -1.0f);
        _cameraUp = glm::vec3(0.0f, 1.0f,  0.0f);
        
        // 创建调试 UI;
        [self createSliders];
        [self createButtons];
        
        // 设置相机;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            CADisplayLink *linker = [CADisplayLink displayLinkWithTarget:self selector:@selector(processRenderCamera)];
            linker.preferredFramesPerSecond = 24;
            [linker addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        });
    }
    return self;
}

#pragma mark - Base Debug UI
- (void)createSliders {
    CGRect fovRect = CGRectMake(40, self.frame.size.height - 100, 295, 30);
    [self sliderView:fovRect tag:1003];
}

- (void)sliderView:(CGRect)rect tag:(NSInteger)iTag {
    // 创建描述标签;
    UILabel * uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x - 20, rect.origin.y, 40, 30)];
    UILabel * uiLabelDes = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + 295 + 10, rect.origin.y, 80, 30)];
    uiLabel.textColor = [UIColor whiteColor];
    uiLabelDes.textColor = [UIColor whiteColor];
    uiLabelDes.tag = iTag + 100;
    if (1003 == iTag) {
        uiLabel.text = @"fov";
        uiLabelDes.text = [NSString stringWithFormat:@"%.2f", self.fov];
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
        uiSlider.value = self.fov;
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
    
    if (1003 == slider.tag) {
        self.fov = slider.value;
    }
}

- (void)createButtons {
    CGRect wRect = CGRectMake((self.frame.size.width - 66) / 2, self.frame.size.height - 280, 66, 66);
    CGRect sRect = CGRectMake((self.frame.size.width - 66) / 2, self.frame.size.height - 210, 66, 66);
    CGRect aRect = CGRectMake((self.frame.size.width - 66 * 3 - 8) / 2, self.frame.size.height - 210, 66, 66);
    CGRect dRect = CGRectMake((self.frame.size.width + 66 + 8) / 2, self.frame.size.height - 210, 66, 66);
    [self buttonView:wRect tag:10000 title:@"W"];
    [self buttonView:sRect tag:10001 title:@"S"];
    [self buttonView:aRect tag:10002 title:@"A"];
    [self buttonView:dRect tag:10003 title:@"D"];
}

- (void)buttonView:(CGRect)rect tag:(NSInteger)iTag title:(NSString *)str {
    CustomButton *btn = [[CustomButton alloc] initWithFrame:rect title:str];
    btn.frame = rect;
    btn.tag = iTag;
    btn.delegate = self;
    btn.backgroundColor = [UIColor redColor];
    [self addSubview:btn];
}

- (void)onTouchedLongTime:(UIView *)view {
    GLfloat cameraSpeed = 5.0f * _deltaTime;
    if (10000 == view.tag) {
        _cameraPos += cameraSpeed * _cameraFront;
    } else if (10001 == view.tag) {
        _cameraPos -= cameraSpeed * _cameraFront;
    } else if (10002 == view.tag) {
        _cameraPos -= glm::normalize(glm::cross(_cameraFront, _cameraUp)) * cameraSpeed;
    } else if (10003 == view.tag) {
        _cameraPos += glm::normalize(glm::cross(_cameraFront, _cameraUp)) * cameraSpeed;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _originalLocation = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    
    CGFloat xoffset = currentLocation.x - _originalLocation.x;
    CGFloat yoffset = currentLocation.y - _originalLocation.y;
    
    GLfloat sensitivity = -0.0025;
    xoffset *= sensitivity;
    yoffset *= -sensitivity;

    _yaw   += xoffset;
    _pitch += yoffset;

    // Make sure that when pitch is out of bounds, screen doesn't get flipped;
    if (_pitch > 89.0f)
        _pitch = 89.0f;
    if (_pitch < -89.0f)
        _pitch = -89.0f;

    glm::vec3 front;
    front.x = cos(glm::radians(_yaw)) * cos(glm::radians(_pitch));
    front.y = sin(glm::radians(_pitch));
    front.z = sin(glm::radians(_yaw)) * cos(glm::radians(_pitch));
    _cameraFront = glm::normalize(front);
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

- (void)deleteBuffers {
    glDeleteRenderbuffers(1, &_renderBuffer);
    self.renderBuffer = 0;
    
    glDeleteFramebuffers(1, &_frameBuffer);
    self.frameBuffer = 0;
}

- (void)bindBuffers {
    // 创建颜色渲染缓冲区;
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, self.renderBuffer);
    [self.eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.eaglLayer];
    
    // 创建渲染缓冲对象;
    int width, height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER,  self.depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height); // 为渲染缓冲对象分配内存空间;
    
    // 创建帧缓冲区;
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, self.frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.renderBuffer);
    
    // 将渲染缓冲对象附加到帧缓冲的深度附件;
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, self.depthBuffer);
    
    // 检查帧缓冲区是否设置好了;
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"ERROR::FRAMEBUFFER:: Framebuffer is not complete!");
    
    // 重新绑定颜色缓冲区;
    glBindRenderbuffer(GL_RENDERBUFFER, self.renderBuffer);
}

- (void)fillVBO {
    GLuint vboID;
    glGenBuffers(1, &vboID);
    glBindBuffer(GL_ARRAY_BUFFER, vboID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    
    GLuint position = glGetAttribLocation(self.displayProgram, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), (void*)(offsetof(VertexStruct, positionCoords)));
    glEnableVertexAttribArray(position);

    GLuint textCoordinate = glGetAttribLocation(self.displayProgram, "textureCoordinate");
    glVertexAttribPointer(textCoordinate, 2, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), (void*)(offsetof(VertexStruct, textureCoords)));
    glEnableVertexAttribArray(textCoordinate);
}

#pragma mark - Process Shader
- (void)loadShaders {
    NSString *vertShaderFile = [[NSBundle mainBundle] pathForResource:@"display" ofType:@"vsh"];
    NSString *fragShaderFile = [[NSBundle mainBundle] pathForResource:@"display" ofType:@"fsh"];
    self.displayProgram = [GLESUtils loadProgram:vertShaderFile withFragmentShaderFilepath:fragShaderFile];
}

#pragma mark - Process Render
- (void)processRenderCamera {
    GLfloat currentFrame = CACurrentMediaTime() / 10;
    _deltaTime = currentFrame - _lastFrame;
    _lastFrame = currentFrame;
    
    glEnable(GL_DEPTH_TEST);
    glClearColor(0, 0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    float width = self.frame.size.width * scale;
    float height = self.frame.size.height * scale;
    GLint originX = self.frame.origin.x * scale;
    GLint originY = self.frame.origin.y * scale;
    glViewport(originX, originY, width, height); // 设置视口大小(这里实际的像素尺寸大小);
    
    glUseProgram(self.displayProgram); // 链接成功才能使用;
    
    [self setPerspectiveProjectionMatrix:self.fov at:(width/height) nZ:0.1f fZ:100.0f]; // 设置投影矩阵;
    
    // 设置观察者矩阵;
    glm::mat4 view;
    float radius = 10.0f;
    self.camX = sin(CACurrentMediaTime()) * radius;
    self.camZ = cos(CACurrentMediaTime()) * radius;
//    view = glm::lookAt(_cameraPos, _cameraPos + _cameraFront, _cameraUp);
    view = glm::lookAt(glm::vec3(self.camX, 0.0, self.camZ), glm::vec3(0.0, 0.0, 0.0), glm::vec3(0.0, 1.0, 0.0));
    glUniformMatrix4fv(glGetUniformLocation(self.displayProgram, "viewMatrix"), 1, GL_FALSE, glm::value_ptr(view));

    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        glm::vec3 cubePositions[] = {
            glm::vec3( 0.0f,  0.0f,  0.0f),
            glm::vec3( 2.0f,  5.0f, -10.0f),
            glm::vec3(-1.5f, -2.2f, -2.5f),
            glm::vec3(-3.8f, -2.0f, -9.3f),
            glm::vec3( 2.4f, -0.4f, -3.5f),
            glm::vec3(-1.7f,  3.0f, -7.5f),
            glm::vec3( 1.3f, -2.0f, -2.5f),
            glm::vec3( 1.5f,  2.0f, -2.5f),
            glm::vec3( 1.5f,  0.2f, -1.5f),
            glm::vec3(-1.3f,  1.0f, -1.5f)
        };
        
        for(unsigned int i = 0; i < 10; i++) {
            glm::mat4 model;
            model = glm::translate(model, cubePositions[i]);
            float angle = 20.0f * i;
            model = glm::rotate(model, glm::radians(angle), glm::vec3(1.0f, 0.3f, 0.5f));

            glUniformMatrix4fv(glGetUniformLocation(self.displayProgram, "modelMatrix"), 1, GL_FALSE, glm::value_ptr(model));

            glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices) / sizeof(VertexStruct));
        }
        
        [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER];
    });
}

- (void)setPerspectiveProjectionMatrix:(float)fovy at:(float)aspect  nZ:(float)nearZ  fZ:(float)farZ {
    GLuint projectionMatrixSlot = glGetUniformLocation(self.displayProgram, "projectionMatrix");
    glm::mat4 projectionMatrix;
    projectionMatrix = glm::perspective(glm::radians(fovy), aspect, nearZ, farZ);
    glUniformMatrix4fv(projectionMatrixSlot, 1, GL_FALSE, glm::value_ptr(projectionMatrix));
}

- (void)setOrthoProjectionMatrix:(float)left r:(float)right b:(float)bottom t:(float)top nZ:(float)nearZ fZ:(float)farZ {
    GLuint projectionMatrixSlot = glGetUniformLocation(self.displayProgram, "projectionMatrix");
    glm::mat4 projectionMatrix;
    projectionMatrix = glm::ortho(left, right, bottom, top, nearZ, farZ);
    glUniformMatrix4fv(projectionMatrixSlot, 1, GL_FALSE, glm::value_ptr(projectionMatrix));
}

- (void)processRotation:(float)fX y:(float)fY z:(float)fZ is3d:(BOOL)is3d {

}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end

