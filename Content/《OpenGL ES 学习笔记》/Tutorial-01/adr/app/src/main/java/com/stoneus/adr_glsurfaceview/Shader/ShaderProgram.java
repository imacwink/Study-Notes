//
//  ShaderProgram.java
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

import android.content.Context;
import android.opengl.GLES20;

import com.stoneus.adr_glsurfaceview.Utils.Utils;

public abstract class ShaderProgram {
    /**
     * uniform 即全局常量，可以随意在任意 shader(vertex shader, geometry shader, or fragment shader) 访问,
     * 不同的 shader 中 uniform 是一起链接的，初始化之后，不能修改其值，否则会引起编译错误;
     **/
    protected static final String U_TEXTURE_UNIT = "u_TextureUnit";

    /**
     *  顶点坐标 & 纹理坐标;
     */
    protected static final String A_POSITION = "a_Position";
    protected static final String A_TEXTURE_COORDINATES = "a_TextureCoordinates";

    /**
     * Shader program 实例 ID;
     */
    protected final int mProgram;

    protected ShaderProgram(Context context, int vertexShaderResourceId,
                            int fragmentShaderResourceId) {
        /**
         * 编译 Shader & 链接 Program;
         */
        mProgram = ShaderUtils.buildProgram(
                Utils.loadShader(context, vertexShaderResourceId),
                Utils.loadShader(context, fragmentShaderResourceId));
    }

    /**
     * 设置应用 Program;
     */
    public void useProgram() {
        GLES20.glUseProgram(mProgram);
    }
}

