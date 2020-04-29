/* 
  display.fsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

uniform lowp vec3 objectColor;
uniform lowp vec3 lightColor;

void main() {
    gl_FragColor = vec4(lightColor * objectColor, 1.0);
}
 
