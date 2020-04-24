//
//  TextureShaderProgram.java
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

import com.stoneus.adr_glsurfaceview.R;

public class TextureShaderProgram extends ShaderProgram {
    /**
     * uniform 即全局常量，可以随意在任意 shader(vertex shader, geometry shader, or fragment shader) 访问,
     * 不同的 shader 中 uniform 是一起链接的，初始化之后，不能修改其值，否则会引起编译错误;
     **/
    private final int mUTextureUnitLocation;

    /**
     *  顶点坐标 & 纹理坐标;
     */
    private final int mAPositionLocation;
    private final int mATextureCoordinatesLocation;

    public TextureShaderProgram(final Context context) {
        super(context, R.raw.texture_vertex, R.raw.texture_fragment);

        /**
         *  获取需要输入的纹理ID变量;
         *  这里应用的 glGetUniformLocation 函数;
         */
        mUTextureUnitLocation = GLES20.glGetUniformLocation(mProgram, U_TEXTURE_UNIT);

        /**
         *  获取顶点坐标&纹理坐标变量;
         *  这里应用的 glGetAttribLocation 函数;
         */
        mAPositionLocation = GLES20.glGetAttribLocation(mProgram, A_POSITION);
        mATextureCoordinatesLocation = GLES20.glGetAttribLocation(mProgram, A_TEXTURE_COORDINATES);
    }

    public void setUniforms(int textureId) {
        /**
         * 激活 TEXTURE0;
         */
        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);

        /**
         * 绑定纹理;
         */
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, textureId);

        /**
         * 通知 Shader 应用纹理;
         */
        GLES20.glUniform1i(mUTextureUnitLocation, 0);
    }

    public int getPositionAttributeLocation() {
        return mAPositionLocation;
    }

    public int getTextureCoordinatesAttributeLocation() {
        return mATextureCoordinatesLocation;
    }
}
