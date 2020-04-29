/* 
  display.fsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

uniform lowp vec3 objectColor;
uniform lowp vec3 lightColor;
uniform lowp float ambientS;

void main() {
    lowp float ambientStrength = ambientS;
    lowp vec3 ambient = ambientStrength * lightColor;
    lowp vec3 result = ambient * objectColor;
    gl_FragColor = vec4(result, 1.0);
}
 
