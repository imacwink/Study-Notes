/* 
  display.vsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

attribute vec4 position;
varying vec4 vColor;
attribute vec4 inputColor;

uniform mat4 projectionMatrix; /*投影矩阵*/
uniform mat4 modelViewMatrix; /*模型矩阵*/

void main() {
    vColor = inputColor;
    gl_Position = projectionMatrix * modelViewMatrix * position;
}
