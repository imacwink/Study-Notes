//
//  GLShaderProgram.m
//  ios-lighting
//
//  Created by 王云刚 on 2020/4/29.
//  Copyright © 2020 王云刚. All rights reserved.
//

#import "GLShaderProgram.h"
#import <GLKit/GLKit.h>
#import "GLESUtils.h"

@interface GLShaderProgram()

@property (nonatomic, assign) GLuint programID;

@end

@implementation GLShaderProgram

- (instancetype)initWithShaderFileName:(NSString *)shaderName {
    self = [super init];
    if (self) {
        NSString *vertShaderFile = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"vsh"];
        NSString *fragShaderFile = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"fsh"];
        _programID = [GLESUtils loadProgram:vertShaderFile withFragmentShaderFilepath:fragShaderFile];
    }
    return self;
}

- (void)use {
    glUseProgram(self.programID);
}

#pragma mark - Base
- (void)setBool:(NSString *)name v:(bool)value {
     glUniform1f(glGetUniformLocation(self.programID, [name UTF8String]), value);
}

- (void)setInt:(NSString *)name v:(int)value {
     glUniform1f(glGetUniformLocation(self.programID, [name UTF8String]), value);
}

- (void)setFloat:(NSString *)name v:(float)value {
     glUniform1f(glGetUniformLocation(self.programID, [name UTF8String]), value);
}

#pragma mark - Vecter
- (void)setVec2:(NSString *)name vec2:(glm::vec2)value {
     glUniform2fv(glGetUniformLocation(self.programID, [name UTF8String]), 1, glm::value_ptr(value));
}

- (void)setVec2:(NSString *)name vec2X:(float)x vec2Y:(float)y {
     glUniform2f(glGetUniformLocation(self.programID, [name UTF8String]), x, y);
}

- (void)setVec3:(NSString *)name vec3:(glm::vec3)value {
    glUniform3fv(glGetUniformLocation(self.programID, [name UTF8String]), 1, glm::value_ptr(value));
}

- (void)setVec3:(NSString *)name vec3X:(float)x vec3Y:(float)y vec3Z:(float)z {
    glUniform3f(glGetUniformLocation(self.programID, [name UTF8String]), x, y, z);
}

- (void)setVec4:(NSString *)name vec4:(glm::vec4)value {
    glUniform4fv(glGetUniformLocation(self.programID, [name UTF8String]), 1, glm::value_ptr(value));
}

- (void)setVec4:(NSString *)name vec4X:(float)x vec4Y:(float)y vec4Z:(float)z vec4W:(float)w {
    glUniform4f(glGetUniformLocation(self.programID, [name UTF8String]), x, y, z, w);
}

#pragma mark - Matrix
- (void)setMat2:(NSString *)name mat2:(glm::mat2)value {
    glUniformMatrix2fv(glGetUniformLocation(self.programID, [name UTF8String]), 1, GL_FALSE, glm::value_ptr(value));
}

- (void)setMat3:(NSString *)name mat3:(glm::mat3)value {
    glUniformMatrix3fv(glGetUniformLocation(self.programID, [name UTF8String]), 1, GL_FALSE, glm::value_ptr(value));
}

- (void)setMat4:(NSString *)name mat4:(glm::mat4)value {
    glUniformMatrix4fv(glGetUniformLocation(self.programID, [name UTF8String]), 1, GL_FALSE, glm::value_ptr(value));
}

@end
