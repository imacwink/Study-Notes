/* 
  display.vsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

attribute vec4 position;
attribute vec2 textureCoordinate;
varying lowp vec2 vTextCoord;

uniform mat4 postionMatrix;  /*输入参数*/

void main() {
    vTextCoord = textureCoordinate;
    vec4 vPos = position;
    vPos = postionMatrix * vPos; /*旋转矩阵运算*/
    gl_Position = vPos;
}
