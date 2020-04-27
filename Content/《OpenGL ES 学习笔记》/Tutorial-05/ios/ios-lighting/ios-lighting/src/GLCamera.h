//
//  GLCamera.h
//  ios-camera
//
//  Created by 王云刚 on 2020/4/22.
//  Copyright © 2020 王云刚. All rights reserved.
//
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

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

// GL import;
#import <glm/glm.hpp>
#import <glm/gtc/matrix_transform.hpp>
#import <glm/gtc/type_ptr.hpp>

NS_ASSUME_NONNULL_BEGIN

enum Camera_Movement {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT
};

@interface GLCamera : NSObject

// 相机属性;
@property (nonatomic, assign) glm::vec3 pos;
@property (nonatomic, assign) glm::vec3 front;
@property (nonatomic, assign) glm::vec3 up;
@property (nonatomic, assign) glm::vec3 right;
@property (nonatomic, assign) glm::vec3 worldUp;

// 欧拉角;
@property (nonatomic, assign) GLfloat yaw;
@property (nonatomic, assign) GLfloat pitch;

// 基础参数;
@property (nonatomic, assign) GLfloat speed;
@property (nonatomic, assign) GLfloat sensitivity;
@property (nonatomic, assign) GLfloat fov;


- (instancetype)initWithVectors:(glm::vec3)posParam
                             up:(glm::vec3)upParam
                            yaw:(GLfloat)yawParam
                          pitch:(GLfloat)pitchParam;

- (glm::mat4)getViewMatrix;
- (void)processMovement:(Camera_Movement)direction deltaTime:(GLfloat)time;
- (void)processTouchMovement:(GLfloat)x yoffset:(GLfloat)y constrainPitch:(GLboolean)isConstrainPitch;
- (void)processFov:(GLfloat) yoffset;

@end

NS_ASSUME_NONNULL_END
