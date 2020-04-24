//
//  GLRender.java
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

package com.stoneus.adr_glsurfaceview.Render;

import android.content.Context;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView;

import com.stoneus.adr_glsurfaceview.Logic.DrawTexture;
import com.stoneus.adr_glsurfaceview.R;
import com.stoneus.adr_glsurfaceview.Shader.TextureShaderProgram;
import com.stoneus.adr_glsurfaceview.Utils.Utils;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

public class GLRender implements GLSurfaceView.Renderer {

    private final Context mContext;
    private DrawTexture mDrawTexture;
    private TextureShaderProgram mTextureShaderProgram;
    private int mTexture;

    public GLRender(final Context context) {
        mContext = context;
    }

    /**
     * 在 surface 创建时回调，通常用于进行初始化工作，只会被回调一次;
     */
    @Override
    public void onSurfaceCreated(GL10 unused, EGLConfig config) {
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

        mDrawTexture = new DrawTexture();
        mTextureShaderProgram = new TextureShaderProgram(mContext);
        mTexture = Utils.loadTexture(mContext, R.drawable.for_test_001);
    }

    /**
     * 在每次 surface 尺寸变化时回调，注意，第一次获取 surface 尺寸时也会回调;
     */
    @Override
    public void onSurfaceChanged(GL10 unused, int width, int height) {
        /**
         * glViewport 是设置 Screen Space 的大小，通常会在 onSurfaceChanged 中调用;
         */
        GLES20.glViewport(0, 0, width, height);
    }

    /**
     * 绘制每一帧数据时回调;
     */
    @Override
    public void onDrawFrame(GL10 unused) {
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT);

        mTextureShaderProgram.useProgram();
        mTextureShaderProgram.setUniforms(mTexture);
        mDrawTexture.bindData(mTextureShaderProgram);
        mDrawTexture.draw();
    }
}