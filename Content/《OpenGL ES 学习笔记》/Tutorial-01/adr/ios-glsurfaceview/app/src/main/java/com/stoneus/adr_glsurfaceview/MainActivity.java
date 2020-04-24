//
//  MainActivity.java
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

package com.stoneus.adr_glsurfaceview;

import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.stoneus.adr_glsurfaceview.Render.GLRender;
import com.stoneus.adr_glsurfaceview.Utils.Utils;

public class MainActivity extends AppCompatActivity {
    private GLSurfaceView mGLSurfaceView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (!Utils.supportGlEs20(this)) {
            Toast.makeText(this, "ES 2.0 not supported!", Toast.LENGTH_LONG).show();
            finish();
            return;
        }

        /**
         * 我们可以理解为他是渲染的“画布”;
         */
        mGLSurfaceView = findViewById(R.id.surface);

        /**
         * 设置渲染环境为ES 2.0;
         */
        mGLSurfaceView.setEGLContextClientVersion(2);

        mGLSurfaceView.setEGLConfigChooser(8, 8, 8, 8, 16, 0);

        /**
         * 设置渲染器，GLRender主要是渲染逻辑处理;
         */
        mGLSurfaceView.setRenderer(new GLRender(this));

        /**
         * RenderMode 有两种，如下:
         * RENDERMODE_WHEN_DIRTY:懒惰渲染，需要手动调用 glSurfaceView.requestRender() 才会进行更新;
         * RENDERMODE_WHEN_DIRTY:不停渲染;
         */
        mGLSurfaceView.setRenderMode(GLSurfaceView.RENDERMODE_CONTINUOUSLY);
    }

    @Override
    protected void onPause() {
        super.onPause();

        if (mGLSurfaceView != null) {
            mGLSurfaceView.onPause();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        if (mGLSurfaceView != null) {
            mGLSurfaceView.onResume();
        }
    }
}
