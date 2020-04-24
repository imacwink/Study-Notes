//
//  ShaderUtils.java
//
//  Created by 王云刚 on 2020/4/11.
//  Copyright © 2020 王云刚. All rights reserved.
//
//
//                 .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//             __.'              ~.   .~              `.__
//           .'//                  \./                  \\`.
//         .'//                     |                     \\`.
//       .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//     .'//.-"                 `-.  |  .-'                 "-.\\`.
//   .'//______.============-..   \ | /   ..-============.______\\`.
// .'______________________________\|/______________________________`.
//

package com.stoneus.adr_glsurfaceview.Shader;

import android.opengl.GLES20;
import android.util.Log;

public final class ShaderUtils {

    private static final String TAG = "ShaderUtils";

    private ShaderUtils() {
    }

    /**
     * 链接着色器程序;
     * @param vertexShader 顶点着色器;
     * @param fragmentShader 片元着色器;
     * @return
     */
    public static int linkProgram(int vertexShader, int fragmentShader) {
        int program = GLES20.glCreateProgram();

        if (program == 0) {
            Log.e(TAG, "create program fail, " + GLES20.glGetProgramInfoLog(program));
            return 0;
        }

        GLES20.glAttachShader(program, vertexShader);
        GLES20.glAttachShader(program, fragmentShader);
        GLES20.glLinkProgram(program);

        int[] linkStatus = new int[1];
        GLES20.glGetProgramiv(program, GLES20.GL_LINK_STATUS, linkStatus, 0);

        if (linkStatus[0] == GLES20.GL_FALSE) {
            Log.e(TAG, "link program fail, " + GLES20.glGetProgramInfoLog(program));
            return 0;
        }

        return program;
    }

    /**
     * 检查当前着色程序的有效性;
     * @param program
     * @return
     */
    public static boolean validateProgram(int program) {
        GLES20.glValidateProgram(program);

        int[] validateStatus = new int[1];
        GLES20.glGetProgramiv(program, GLES20.GL_VALIDATE_STATUS, validateStatus, 0);

        Log.i(TAG, "validateProgram: " + validateStatus[0] + ", " + GLES20.glGetProgramInfoLog(program));

        return validateStatus[0] == GLES20.GL_TRUE;
    }

    /**
     * 编译着色器;
     * @param type 着色器类型;
     * @param shader 着色器字符数据;
     * @return
     */
    private static int compileShader(int type, String shader) {
        int shaderObj = GLES20.glCreateShader(type);

        if (shaderObj == 0) {
            Log.e(TAG, "create shader obj fail: " + type);
            return 0;
        }

        GLES20.glShaderSource(shaderObj, shader);
        GLES20.glCompileShader(shaderObj);

        final int[] compileStatus = new int[1];
        GLES20.glGetShaderiv(shaderObj, GLES20.GL_COMPILE_STATUS, compileStatus, 0);

        if (compileStatus[0] == GLES20.GL_FALSE) {
            Log.e(TAG, "compile shader code fail: " + type + ", " + GLES20.glGetShaderInfoLog(shaderObj));
            GLES20.glDeleteShader(shaderObj);
            return 0;
        }

        return shaderObj;
    }

    /**
     * 执行着色器的编译和链接操作;
     * @param vertexShaderSource
     * @param fragmentShaderSource
     * @return
     */
    public static int buildProgram(String vertexShaderSource, String fragmentShaderSource) {
        int program;

        /**
         * 编译;
         */
        int vertexShader = compileShader(GLES20.GL_VERTEX_SHADER, vertexShaderSource);
        int fragmentShader = compileShader(GLES20.GL_FRAGMENT_SHADER, fragmentShaderSource);

        /**
         * 链接;
         */
        program = linkProgram(vertexShader, fragmentShader);

        /**
         * 校验;
         */
        validateProgram(program);

        return program;
    }
}
