# ios-mvp

>It always seems impossible until its done.<br>
在事情未成功之前，一切总看似不可能。<br>
　　　　　　　　　　　　　　　-----《曼德拉》

## 环境

>XCode Version 11.3.1 (11C504)<br>
OpenGL ES 2.0<br>

## 目的

>前面我们简单的讲解和DEMO了下GLKit和GLES在iOS端的基本绘制流程和简单的矩阵运算，对GLES和Shader有了简单的认识和了解，对于矩阵的简单运算也有了一定的基础（如果看了前面的文章，同时做了相关专项学习的童鞋），接下来本章将主要讲解模型（Model）、观察（View）和投影（Projection）矩阵在GLES渲染中的实际应用。

## 效果

<img src="../res/cube.jpeg" width="25%" height="25%"><img src="../res/image.gif" width="25%" height="25%"><br>
<img src="../res/colorcube.gif" width="25%" height="25%"><img src="../res/imgecube.gif" width="25%" height="25%">

## 复合变换：模型观察投影矩阵（MVP）