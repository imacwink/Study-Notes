//
//  GLCamera.m
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

#import "GLCamera.h"

// 默认的相机参数;
const GLfloat SPEED      =  3.0f;
const GLfloat SENSITIVTY =  0.005f;
const GLfloat FOV       =  45.0f;

@implementation GLCamera

- (instancetype)initWithVectors:(glm::vec3)posParam
                             up:(glm::vec3)upParam
                            yaw:(GLfloat)yawParam
                          pitch:(GLfloat)pitchParam {
    self = [super init];
    if (self) {
        _pos = posParam;
        _worldUp = upParam;
        _yaw = yawParam;
        _pitch = pitchParam;
        
        _front = glm::vec3(0.0f, 0.0f, -1.0f);
        _speed = SPEED;
        _sensitivity = SENSITIVTY;
        _fov = FOV;
        
        [self updateCameraVectors];
    }
    return self;
}

- (void)updateCameraVectors {
    glm::vec3 front;
    front.x = cos(glm::radians(_yaw)) * cos(glm::radians(_pitch));
    front.y = sin(glm::radians(_pitch));
    front.z = sin(glm::radians(_yaw)) * cos(glm::radians(_pitch));
    _front = glm::normalize(front);
    _right = glm::normalize(glm::cross(_front, _worldUp));
    _up = glm::normalize(glm::cross(_right, _front));
}

- (glm::mat4)getViewMatrix {
    return glm::lookAt(_pos, _pos + _front, _up);
}

- (void)processMovement:(Camera_Movement)direction deltaTime:(GLfloat)time {
    GLfloat velocity = _speed * time;
    if (direction == FORWARD)
        _pos += _front * velocity;
    if (direction == BACKWARD)
        _pos -= _front * velocity;
    if (direction == LEFT)
        _pos -= _right * velocity;
    if (direction == RIGHT)
        _pos += _right * velocity;
}

- (void)processTouchMovement:(GLfloat)x yoffset:(GLfloat)y constrainPitch:(GLboolean)isConstrainPitch {
    x *= _sensitivity;
    y *= _sensitivity;

    _yaw += x;
    _pitch += y;

    if (isConstrainPitch) {
        if (_pitch > 89.0f)
            _pitch = 89.0f;
        if (_pitch < -89.0f)
            _pitch = -89.0f;
    }

    [self updateCameraVectors];
}

- (void)processFov:(GLfloat) fov {
    _fov = fov;
}

@end
