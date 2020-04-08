/* 
  display.fsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

varying lowp vec2 vTextCoord;
uniform sampler2D colorMap;
void main() {
    gl_FragColor = texture2D(colorMap, vTextCoord);
}
