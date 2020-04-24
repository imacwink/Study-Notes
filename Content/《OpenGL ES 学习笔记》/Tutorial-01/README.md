# Tutorial-01

>万事开头难，每门科学都是如此。<br>
　　　　　　　　　　　　　　　-----《马克思》

## 背景

>从移动端入手，了解移平台 EGL 的封装，在归纳统一采用 C++ 辅以实现，输出 DEMO 以供没有太多 GLES 开发经验的同学快速理解和上手，当然也能够辅助自己回头查阅和学习；开篇先从简单的GLKit（iOS）和 GLSurfaceView（Adr）入手，首先演示如何通过 GL 状态指令将一张图片（我们俗称纹理）绘制到移动设备上。

## 环境

>iOS：XCode Version 11.3.1 (11C504)<br>
Adr：Android Studio Version 3.5.3 (6010548)<br>
OpenGL ES 2.0<br>

## adr-glsurfaceview