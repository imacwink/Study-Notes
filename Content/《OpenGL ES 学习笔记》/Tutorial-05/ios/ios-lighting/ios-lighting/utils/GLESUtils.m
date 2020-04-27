//
//  GLESUtils.m
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


#import "GLESUtils.h"

#define DEBUG 1 // 便于调试添加 DEBUG;

@implementation GLESUtils

+ (GLuint)loadShader:(GLenum)type withFilepath:(NSString *)shaderFilepath {
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderFilepath 
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (!shaderString) {
        NSLog(@"Error: loading shader file: %@ %@", shaderFilepath, error.localizedDescription);
        return 0;
    }
    
    return [self loadShader:type withString:shaderString];
}

+ (GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString {
    // 创建 Shader 对象;
    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        NSLog(@"Error: failed to create shader.");
        return 0;
    }
    
    // 加载 Shader;
    const char * shaderStringUTF8 = [shaderString UTF8String];
    glShaderSource(shader, 1, &shaderStringUTF8, NULL);
    
    // 编译 Shader;
    glCompileShader(shader);
    
    // 检查编译状态;
    #if defined(DEBUG)
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv ( shader, GL_INFO_LOG_LENGTH, &infoLen );
        
        if (infoLen > 1) {
            char * infoLog = malloc(sizeof(char) * infoLen);
            glGetShaderInfoLog (shader, infoLen, NULL, infoLog);
            NSLog(@"Error compiling shader:\n%s\n", infoLog );            
            
            free(infoLog);
        }
        
        glDeleteShader(shader);
        return 0;
    }
    #endif

    return shader;
}

+ (GLuint)loadProgram:(NSString *)vertexShaderFilepath withFragmentShaderFilepath:(NSString *)fragmentShaderFilepath {
    // 读取 vertex/fragment 着色器;
    GLuint vertexShader = [self loadShader:GL_VERTEX_SHADER
                              withFilepath:vertexShaderFilepath];
    if (vertexShader == 0)
        return 0;
    
    GLuint fragmentShader = [self loadShader:GL_FRAGMENT_SHADER
                                withFilepath:fragmentShaderFilepath];
    if (fragmentShader == 0) {
        glDeleteShader(vertexShader);
        return 0;
    }
    
    // 创建一个 ShaerProgram 对象;
    GLuint programHandle = glCreateProgram();
    if (programHandle == 0)
        return 0;
    
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    
    // 链接;
    glLinkProgram(programHandle);
    
    // 检查链接状态;
    #if defined(DEBUG)
    GLint linked;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linked);
    
    if (!linked) {
        GLint infoLen = 0;
        glGetProgramiv(programHandle, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1){
            char * infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(programHandle, infoLen, NULL, infoLog);

            NSLog(@"Error linking program:\n%s\n", infoLog);            
            
            free(infoLog);
        }
        
        glDeleteProgram(programHandle);
        return 0;
    }
    #endif
    
    // 清理不在使用的 Shader 资源;
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return programHandle;
}

+ (GLuint)fillTexture:(NSString *)fileName {
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

@end
