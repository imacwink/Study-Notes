## 第03章  Shader Language
<br>

> 我们全都要从前辈和同辈学习到一些东西。就连最大的天才，如果想单凭他所特有的内在自我去对付一切，他也决不会有多大成就。<br>
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　------ 歌德

　　In the last year I have never had to write a single HLSL/GLSL shader. Bottom line, I can't think of any reason NOT to use CG.
<br><br>
　　Shader Language, 称为着色语言，Shader 在英语中的意思是阴影、颜色深浅的意思，Wikipedia 上对 Shader Language 的解释为“The job of a surface shading procedure is to choose a color for each pixel on a surface, incorporating any variations in color of the surface itself and the effects of lights that shine on the surface(Marc Olano)”, 即，Shader Language 基于物体本身属性和光照条件，计算每个像素的颜色值。
<br><br>
　　实际上这种解释具有明显的时代局限性，在 GPU 编程发展的早期，Shader Language 的提出目标是加强对图形处理算法的控制，所以对该语言的定义亦针对于此。但对这技术的进步，目前的 Shader Language 早已经用于通用计算研究。
<br><br>
　　Shader Language 被定为为高级语言，如，GLSL 的全称是“High Level Shading Language”，Cg 语言的全称为“C for Graphic”，并且这两种 Shader Language 的语法设计非常类似于 C 语言。不过高级语言的一个重要特性是“独立于硬件”，在这一方面 Shader Language 暂时还做不到，Shader Language 完全依赖于 GPU 架构，这一特征在现阶段是非常明显的！任意一种 Shader Language 都必须基于图形硬件，所以 GPU 编程技术的发展本质上还是图形硬件的发展。在 Shader Language 存在之前，展示基于图形硬件的编程能力只能靠低级的汇编语言。
<br><br>
　　目前，Shader Language 的发展方向是设计出编辑性方面可以和C++\JAVA相比的高级语言，“赋予程序员灵活而方便的编程方式”，并“尽可能的控制渲染过程”同时“利用图形硬件的并行性，提高算法的效率”。Shader Language 目前主要有 3 种语言：基于 OpenGL 的GLSL，基于 Direct3D 的HLSL，还有 NVIDIA 公司的 Cg 语言。
<br><br>
　　本章的目的是阐述 Shader Language 的基本原理和运行流程，首先从硬件的角度对 Programmable Vertex Processor（可编程顶点处理器，又称为顶点着色器）和Programmable Fragment Processor（可编程片断处理器，又称为片断着色器）的作用进行阐述，然后再此基础上对 Vertex Program 和 Fragment Program 进行具体论述，最后对 GLSL、HLSL 和 Cg 进行比较。
<br>

### 3.1 Shader Language 原理











