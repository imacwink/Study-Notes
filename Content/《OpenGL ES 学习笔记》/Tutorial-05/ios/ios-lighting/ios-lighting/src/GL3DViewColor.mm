//
//  GL3DViewColor.m
//  ios-camera
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

#import "GL3DViewColor.h"
#import "GLESUtils.h"
#import "CustomButton.h"
#import "GLCamera.h"
#import "GLShaderProgram.h"

#define DEBUG 1 // 便于调试添加 DEBUG;

@interface GL3DViewColor() <CustomButtonDelegate> {
    GLCamera *_glCamera;
    glm::vec3 _lightPos;
}

@property(nonatomic, strong) EAGLContext *eaglContext;
@property (nonatomic, strong) CAEAGLLayer *eaglLayer;

@property (nonatomic, strong) GLShaderProgram *lightShader;
@property (nonatomic, strong) GLShaderProgram *baseLightShader;
@property (nonatomic, strong) GLShaderProgram *ambientShader;
@property (nonatomic, strong) GLShaderProgram *diffuseShader;
@property (nonatomic, strong) GLShaderProgram *specularShader;

@property (nonatomic, assign) GLuint renderBuffer;
@property (nonatomic, assign) GLuint frameBuffer;
@property (nonatomic, assign) GLuint depthBuffer;

@property (nonatomic, assign) GLfloat ambientS;

@end

@implementation GL3DViewColor

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
        
        self.ambientS = 0.1f;
        _lightPos = glm::vec3(1.2f, 2.5f, 0.0f);
        [self createSliders];
        
        // VBO处理;
        [self fillVBO];
        
        // 创建一个比较搓的相机 PS：和U3D的相机比这可能是一坨屎;
        _glCamera = [[GLCamera alloc] initWithVectors:glm::vec3(0.0f, 0.0f,  3.0f)
                                                   up:glm::vec3(0.0f, 1.0f,  0.0f)
                                                  yaw:-90.0f
                                                pitch:0.0f];
        // 处理相机渲染;
        [self processRenderCamera];
        
    }
    return self;
}

#pragma mark - Base Debug UI
- (void)createSliders {
    CGRect fovRect = CGRectMake(80, self.frame.size.height - 100, 280, 30);
    [self sliderView:fovRect tag:1003];
}

- (void)sliderView:(CGRect)rect tag:(NSInteger)iTag {
    // 创建描述标签;
    UILabel * uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x - 65, rect.origin.y, 80, 30)];
    UILabel * uiLabelDes = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + 280 + 10, rect.origin.y, 80, 30)];
    uiLabel.textColor = [UIColor whiteColor];
    uiLabelDes.textColor = [UIColor whiteColor];
    uiLabelDes.tag = iTag + 100;
    uiLabel.text = @"ambient";
    uiLabelDes.text = [NSString stringWithFormat:@"%.2f", 50.0f];
    [self addSubview:uiLabel];
    [self addSubview:uiLabelDes];
    
    // 实例化UISlider，高度对外观没有影响;
    UISlider * uiSlider = [[UISlider alloc] initWithFrame:rect];
    uiSlider.tag = iTag;
    
    // 设置Slider的最大值和最小值;
    uiSlider.maximumValue = 1.0;
    uiSlider.minimumValue = 0;
      
    // 设置Slider的值，thumb会跳到对应的位置;
    uiSlider.value = 0.5f;
    
    // 添加Slider滑动事件;
    [uiSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
     
    // 把Slider添加到view上;
    [self addSubview:uiSlider];
}

- (void)sliderValueChanged:(UISlider *)slider {
    UILabel *uiLabel = (UILabel *)[self viewWithTag:(slider.tag + 100)];
    NSString *myString = [NSString stringWithFormat:@"%.2f", slider.value];
    uiLabel.text = myString;
    self.ambientS = slider.value;
    [self processRenderCamera];
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
    
    float vertices[] = {
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
         0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
         0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
         0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,

        -0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
         0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
         0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
         0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,

        -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,

         0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
         0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
         0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
         0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
         0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
         0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,

        -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
         0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
         0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
         0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,

        -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
         0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
         0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
         0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f
    };
    
    // position attribute
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    // normal attribute
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    
//    // postion attribute;
//    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), (void*)(offsetof(VertexStruct, positionCoords)));
//    glEnableVertexAttribArray(0);
//    
//    // normal attribute;
//    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(VertexStruct), (void*)(offsetof(VertexStruct, normalCoords)));
//    glEnableVertexAttribArray(1);
}

#pragma mark - Process Shader
- (void)loadShaders {
    self.lightShader = [[GLShaderProgram alloc] initWithShaderFileName:@"lighting"];
    self.baseLightShader = [[GLShaderProgram alloc] initWithShaderFileName:@"display-color"];
    self.ambientShader = [[GLShaderProgram alloc] initWithShaderFileName:@"display-ambient"];
    self.diffuseShader = [[GLShaderProgram alloc] initWithShaderFileName:@"display-diffuse"];
    self.specularShader = [[GLShaderProgram alloc] initWithShaderFileName:@"display-specular"];
}

#pragma mark - Process Render
- (void)processRenderCamera {    
    glEnable(GL_DEPTH_TEST);
    glClearColor(0, 0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    float width = self.frame.size.width * scale;
    float height = self.frame.size.height * scale;
    GLint originX = self.frame.origin.x * scale;
    GLint originY = self.frame.origin.y * scale;
    glViewport(originX, originY, width, height); // 设置视口大小(这里实际的像素尺寸大小);
    
    glm::mat4 view = [_glCamera getViewMatrix];
    glm::mat4 projection = glm::perspective(_glCamera.fov, width/height, 0.1f, 100.0f);
    int count = sizeof(vertices) / sizeof(VertexStruct);
    
    // 绘制光源;
    {
        [self.lightShader use];

        // 设置MVP矩阵;
        [self.lightShader setMat4:@"view" mat4:view];
        [self.lightShader setMat4:@"projection" mat4:projection];

        glm::mat4 lightingModel;
        lightingModel = glm::scale(lightingModel, glm::vec3(0.3f, 0.3f, 0.3f));
        lightingModel = glm::translate(lightingModel, _lightPos);
        lightingModel = glm::rotate(lightingModel, glm::radians(25.0f), glm::vec3(0.0f, 1.0f, 0.0f));
        [self.lightShader setMat4:@"model" mat4:lightingModel];

        // 渲染;
        glDrawArrays(GL_TRIANGLES, 0, count);
    }
    
    // 绘制物体;
    {
        [self.baseLightShader use];

        // 设置MVP矩阵;
        [self.baseLightShader setMat4:@"view" mat4:view];
        [self.baseLightShader setMat4:@"projection" mat4:projection];

        glm::mat4 model;
        model = glm::scale(model, glm::vec3(0.5f, 0.5f, 0.5f));
        model = glm::translate(model, glm::vec3(-0.7f, 0.0f, 0.0f));
        model = glm::rotate(model, glm::radians(25.0f), glm::vec3(0.0f, 1.0f, 0.0f));
        [self.baseLightShader setMat4:@"model" mat4:model];

        // 设置颜色;
        [self.baseLightShader setVec3:@"objectColor" vec3X:1.0f vec3Y:0.5f vec3Z:0.31f]; // 物体颜色：珊瑚红;
        [self.baseLightShader setVec3:@"lightColor" vec3X:1.0f vec3Y:1.0f vec3Z:1.0f]; // 光源颜色：白色;

        // 渲染;
        glDrawArrays(GL_TRIANGLES, 0, count);
    }
    

    // 绘制物体（ambient）;
    {
        [self.ambientShader use];

        // 设置MVP矩阵;
        [self.ambientShader setMat4:@"view" mat4:view];
        [self.ambientShader setMat4:@"projection" mat4:projection];

        glm::mat4 model;
        model = glm::scale(model, glm::vec3(0.5f, 0.5f, 0.5f));
        model = glm::translate(model, glm::vec3(0.8f, 0.0f, 0.0f));
        model = glm::rotate(model, glm::radians(25.0f), glm::vec3(0.0f, 1.0f, 0.0f));
        [self.ambientShader setMat4:@"model" mat4:model];

        // 设置颜色;
        [self.ambientShader setVec3:@"objectColor" vec3X:1.0f vec3Y:0.5f vec3Z:0.31f]; // 物体颜色：珊瑚红;
        [self.ambientShader setVec3:@"lightColor" vec3X:1.0f vec3Y:1.0f vec3Z:1.0f]; // 光源颜色：白色;
        [self.ambientShader setFloat:@"ambientS" v:self.ambientS];

        // 渲染;
        glDrawArrays(GL_TRIANGLES, 0, count);
    }
    
    // 绘制物体（diffuse）;
    {
        [self.diffuseShader use];

        // 设置MVP矩阵;
        [self.diffuseShader setMat4:@"view" mat4:view];
        [self.diffuseShader setMat4:@"projection" mat4:projection];

        glm::mat4 model;
        model = glm::scale(model, glm::vec3(0.5f, 0.5f, 0.5f));
        model = glm::translate(model, glm::vec3(-0.8f, -1.5f, 0.0f));
        model = glm::rotate(model, glm::radians(25.0f), glm::vec3(0.0f, 1.0f, 0.0f));
        [self.diffuseShader setMat4:@"model" mat4:model];

        // 设置颜色;
        [self.diffuseShader setFloat:@"ambientS" v:self.ambientS];
        [self.diffuseShader setFloat:@"specularS" v:self.ambientS];
        [self.diffuseShader setVec3:@"objectColor" vec3X:1.0f vec3Y:0.5f vec3Z:0.31f]; // 物体颜色：珊瑚红;
        [self.diffuseShader setVec3:@"lightColor" vec3X:1.0f vec3Y:1.0f vec3Z:1.0f]; // 光源颜色：白色;
        [self.diffuseShader setVec3:@"lightPos" vec3:_lightPos];

        // 渲染;
        glDrawArrays(GL_TRIANGLES, 0, count);
    }
    
    // 绘制物体（specular）;
    {
        [self.specularShader use];

        // 设置MVP矩阵;
        [self.specularShader setMat4:@"view" mat4:view];
        [self.specularShader setMat4:@"projection" mat4:projection];

        glm::mat4 model;
        model = glm::scale(model, glm::vec3(0.5f, 0.5f, 0.5f));
        model = glm::translate(model, glm::vec3(0.8f, -1.5f, 0.0f));
        model = glm::rotate(model, glm::radians(25.0f), glm::vec3(0.0f, 1.0f, 0.0f));
        [self.specularShader setMat4:@"model" mat4:model];

        // 设置颜色;
        [self.specularShader setVec3:@"objectColor" vec3X:1.0f vec3Y:0.5f vec3Z:0.31f]; // 物体颜色：珊瑚红;
        [self.specularShader setVec3:@"lightColor" vec3X:1.0f vec3Y:1.0f vec3Z:1.0f]; // 光源颜色：白色;
        [self.specularShader setFloat:@"ambientS" v:self.ambientS];
        [self.specularShader setVec3:@"lightPos" vec3:_lightPos];
        [self.specularShader setVec3:@"viewPos" vec3:_glCamera.pos];
        glm::mat3 inverseModel = glm::inverse(model);
        glm::mat3 temp = glm::transpose(inverseModel);
        [self.diffuseShader setMat3:@"normalTemp" mat3:temp];

        // 渲染;
        glDrawArrays(GL_TRIANGLES, 0, count);
    }

    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end

