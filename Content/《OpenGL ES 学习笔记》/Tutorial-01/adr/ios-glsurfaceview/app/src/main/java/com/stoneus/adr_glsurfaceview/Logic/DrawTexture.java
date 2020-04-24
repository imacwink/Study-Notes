//
//  DrawTexture.java
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

package com.stoneus.adr_glsurfaceview.Logic;

import android.opengl.GLES20;

import com.stoneus.adr_glsurfaceview.Geometry.VertexArray;
import com.stoneus.adr_glsurfaceview.Shader.TextureShaderProgram;
import com.stoneus.adr_glsurfaceview.Utils.Utils;

public class DrawTexture {
    private static final int POSITION_COMPONENT_COUNT = 2;
    private static final int TEXTURE_COORDINATES_COMPONENT_COUNT = 2;
    private static final int STRIDE = (POSITION_COMPONENT_COUNT
            + TEXTURE_COORDINATES_COMPONENT_COUNT)
            * Utils.BYTES_PER_FLOAT;

    /**
     * 顶点坐标(X, Y)也称之为 Vertex 坐标, 纹理坐标(S, T)也可以称之为 UV 坐标;
     */
    private static final float[] VERTEX_DATA = {
            /**
             * 右上三角形;
             */
            1.0f, -1.0f, 1.0f, 0.0f, // 右下;
            1.0f, 1.0f, 1.0f, 1.0f, // 右上;
            -1.0f, 1.0f, 0.0f, 1.0f, // 左上;

            /**
             * 左下三角形;
            */
            1.0f, -1.0f, 1.0f, 0.0f, // 右下;
            -1.0f, 1.0f, 0.0f, 1.0f, // 左上;
            -1.0f, -1.0f, 0.0f, 0.0f, // 左下;
    };

    private final VertexArray mVertexArray;

    public DrawTexture() {
        mVertexArray = new VertexArray(VERTEX_DATA);
    }

    public void bindData(TextureShaderProgram textureProgram) {
        mVertexArray.setVertexAttribPointer(
                0,
                textureProgram.getPositionAttributeLocation(),
                POSITION_COMPONENT_COUNT,
                STRIDE);

        mVertexArray.setVertexAttribPointer(
                POSITION_COMPONENT_COUNT,
                textureProgram.getTextureCoordinatesAttributeLocation(),
                TEXTURE_COORDINATES_COMPONENT_COUNT,
                STRIDE);
    }

    public void draw() {
        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 6);
    }
}