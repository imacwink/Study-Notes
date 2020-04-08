/* 
  display.vsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

attribute vec4 position;
attribute vec2 textureCoordinate;
varying lowp vec2 vTextCoord;
void main() {
    vTextCoord = textureCoordinate;
    gl_Position = position;
}
