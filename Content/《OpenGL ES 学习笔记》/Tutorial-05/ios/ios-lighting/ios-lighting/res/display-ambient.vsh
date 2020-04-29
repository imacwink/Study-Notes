/* 
  display.vsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

attribute vec4 position;

uniform mat4 projection; /*投影矩阵*/
uniform mat4 model; /*模型矩阵*/
uniform mat4 view; /*观察者矩阵*/

void main() {
    gl_Position = projection * view * model * vec4(position.xyz, 1.0);
}
