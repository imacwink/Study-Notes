/* 
  display.vsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

attribute vec4 position;
attribute vec2 textureCoordinate;
varying lowp vec2 vTextCoord;

uniform mat4 projectionMatrix; /*投影矩阵*/
uniform mat4 modelMatrix; /*模型矩阵*/
uniform mat4 viewMatrix; /*观察者矩阵*/

void main() {
    vTextCoord = textureCoordinate;
    vec4 vPos;
    vPos = projectionMatrix * viewMatrix * modelMatrix * position;
    gl_Position = vPos;
}
