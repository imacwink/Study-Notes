/* 
  display.vsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

attribute vec4 position;
attribute vec3 normal;

varying lowp vec3 Normal;
varying lowp vec3 FragPos;

uniform mat4 projection; /*投影矩阵*/
uniform mat4 model; /*模型矩阵*/
uniform mat4 view; /*观察者矩阵*/

void main() {
    FragPos = vec3(model * vec4(position.xyz, 1.0));
    Normal = normal;
     
    gl_Position = projection * view * vec4(FragPos, 1.0);
}
