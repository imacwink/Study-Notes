//
//  GLShaderProgram.h
//  ios-lighting
//
//  Created by 王云刚 on 2020/4/29.
//  Copyright © 2020 王云刚. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <glm/glm.hpp>
#import <glm/gtc/matrix_transform.hpp>
#import <glm/gtc/type_ptr.hpp>

NS_ASSUME_NONNULL_BEGIN

@interface GLShaderProgram : NSObject

- (instancetype)initWithShaderFileName:(NSString *)shaderName;

- (void)use;

// 基础类型;
- (void)setBool:(NSString *)name v:(bool)value;
- (void)setInt:(NSString *)name v:(int)value;
- (void)setFloat:(NSString *)name v:(float)value;

// 向量类型;
- (void)setVec2:(NSString *)name vec2:(glm::vec2)value;
- (void)setVec2:(NSString *)name vec2X:(float)x vec2Y:(float)y;
- (void)setVec3:(NSString *)name vec3:(glm::vec3)value;
- (void)setVec3:(NSString *)name vec3X:(float)x vec3Y:(float)y vec3Z:(float)z;
- (void)setVec4:(NSString *)name vec4:(glm::vec4)value;
- (void)setVec4:(NSString *)name vec4X:(float)x vec4Y:(float)y vec4Z:(float)z vec4W:(float)w;

// 矩阵类型;
- (void)setMat2:(NSString *)name mat2:(glm::mat2)value;
- (void)setMat3:(NSString *)name mat3:(glm::mat3)value;
- (void)setMat4:(NSString *)name mat4:(glm::mat4)value;

@end

NS_ASSUME_NONNULL_END
