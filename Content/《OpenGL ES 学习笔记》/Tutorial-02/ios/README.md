## ios-shader

>引擎推动的不是飞船而是宇宙。飞船压根就没动过。<br>
　　　　　　　　　　　　　　　-----《飞出个未来》

### 环境

>XCode Version 11.3.1 (11C504)<br>
OpenGL ES 2.0<br>

### 目的

>通过 UIView 和 OpenGL ES 2.0 相关基础展示一张纹理的渲染效果，同时不在应用 iOS 提供的着色器封装类 GLKBaseEffect， 而是采用自定义 Shader，完成纹理的平移、放缩和旋转等基本操作，这里强烈建议阅读一下之前整理的 [GPU 编程与 CG 语言之阳春白雪下里巴人](https://github.com/yungangwang/Study-Notes/tree/master/Content/%E3%80%8AGPU%20%E7%BC%96%E7%A8%8B%E4%B8%8E%20CG%20%E8%AF%AD%E8%A8%80%E4%B9%8B%E9%98%B3%E6%98%A5%E7%99%BD%E9%9B%AA%E4%B8%8B%E9%87%8C%E5%B7%B4%E4%BA%BA%E3%80%8B) 认真学习 CG 的基础知识。

### 效果

<img src="../res/001.jpeg" width="35%" height="35%">
<img src="../res/postion.gif" width="35%" height="35%">
<img src="../res/scale.gif" width="35%" height="35%">
<img src="../res/rotation.gif" width="35%" height="35%">

### 矩阵

>矩阵的理解是学好CG最重要的一个环节，建议多思考，多动手，多阅读相关资料，这里处于本章节考虑，只做简单的变换矩阵讲解，并不会对齐次坐标、模型、观察和投影矩阵做讲解

#### 放缩

- 局部放缩（相对坐标原点的比例变换 A（x，y，z）旋转后变为A'（xSx， ySy， zSz）, Sx, Sy, Sz为缩放因子缩放变换矩阵为）

$$
\left[
 \begin{matrix}
   Sx & 0 & 0 & 0 \\
   0 & Sy & 0 & 0 \\
   0 & 0 & Sz & 1 \\
   0 & 0 & 0 & 1
  \end{matrix} 
\right]
$$

- 整体放缩（放缩矩阵为）

$$
\left[
 \begin{matrix}
   1 & 0 & 0 & 0 \\
   0 & 1 & 0 & 0 \\
   0 & 0 & 1 & 1 \\
   0 & 0 & 0 & s
  \end{matrix} 
\right]
$$

#### 旋转

#### 平移

- 平移向量 P 为（tx, ty, tz）， 点 A （x, y, z）平移后变为 A‘（x + tx, y + ty, z + tz）点 A 的矩阵为[x, y, z, 1]，平移变换矩阵为

$$
\left[
 \begin{matrix}
   1 & 0 & 0 & 0 \\
   0 & 1 & 0 & 0 \\
   0 & 0 & 1 & 1 \\
   tx & ty & tz & 1
  \end{matrix} 
\right]
$$

- 点 A 的矩阵乘以平移变换矩阵得到平移后的矩阵为



#### 思考

- 三维顶点坐标(x,y,z)，现在引入一个新的分量w，得到向量(x,y,z,w)，那么 w 是 0 或者 1 有什么区别？
- 平移变换中，左乘和右乘对于平移矩阵会有什么不同？
- 为什么我讲解的顺序是放缩、旋转、平移？


### 步骤
