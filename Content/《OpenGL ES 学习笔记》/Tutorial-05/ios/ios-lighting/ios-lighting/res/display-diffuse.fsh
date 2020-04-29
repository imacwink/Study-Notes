/* 
  display.fsh
  ios-shader

  Created by 王云刚 on 2020/4/5.
  Copyright © 2020 王云刚. All rights reserved.
*/

varying lowp vec3 Normal;
varying lowp vec3 FragPos;

uniform lowp vec3 lightPos;
uniform lowp vec3 objectColor;
uniform lowp vec3 lightColor;
uniform lowp float ambientS;

void main() {
    // ambient;
    lowp float ambientStrength = ambientS;
    lowp vec3 ambient = ambientStrength * lightColor;
      
    // diffuse;
    lowp vec3 norm = normalize(Normal);
    lowp vec3 lightDir = normalize(lightPos - FragPos);
    lowp float diff = max(dot(norm, lightDir), 0.0);
    lowp vec3 diffuse = diff * lightColor;
            
    lowp vec3 result = (ambient + diffuse) * objectColor;
    gl_FragColor = vec4(result, 1.0);
}
 
