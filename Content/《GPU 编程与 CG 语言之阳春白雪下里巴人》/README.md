# GPU 编程与 CG 语言之阳春白雪下里巴人
> 这是一本非常不错的入门级 GPU 开发书籍，推荐指数五星，市面上流通的大多是 PDF 格式，不方便阅读，在学习之余将其利用技术手段和人工修正的方式改写成了  Markdown 格式，这样更方便读者阅读。<br>
原著作者：[康玉之]() <br>
Markdown 作者：[小萝卜]() <br> 
WeChat ID：[macwink]() <br> 

## [第1章 绪论](https://github.com/yungangwang/Study-Notes/blob/master/Content/%E3%80%8AGPU%20%E7%BC%96%E7%A8%8B%E4%B8%8E%20CG%20%E8%AF%AD%E8%A8%80%E4%B9%8B%E9%98%B3%E6%98%A5%E7%99%BD%E9%9B%AA%E4%B8%8B%E9%87%8C%E5%B7%B4%E4%BA%BA%E3%80%8B/%E3%80%8A%E7%AC%AC01%E7%AB%A0%20%20%E7%BB%AA%E8%AE%BA%E3%80%8B.md)
> ### 1.1 Programmable Graphics Processing Unit 发展历史<br>
> ### 1.2 GPU VS CPU<br>
> ### 1.3 国内外研究现状<br>
> ### 1.4 本书主要内容和结构<br>
## [第2章 GPU 图形绘制管线](https://github.com/yungangwang/Study-Notes/blob/master/Content/%E3%80%8AGPU%20%E7%BC%96%E7%A8%8B%E4%B8%8E%20CG%20%E8%AF%AD%E8%A8%80%E4%B9%8B%E9%98%B3%E6%98%A5%E7%99%BD%E9%9B%AA%E4%B8%8B%E9%87%8C%E5%B7%B4%E4%BA%BA%E3%80%8B/%E3%80%8A%E7%AC%AC02%E7%AB%A0%20%20GPU%E5%9B%BE%E5%BD%A2%E7%BB%98%E5%88%B6%E7%AE%A1%E7%BA%BF%E3%80%8B.md)
> ### 2.1 几何阶段<br>
>
>> #### 2.1.1 从 object space 到 world space<br>
>> #### 2.1.2 从 world space 到 eye space<br>
>> #### 2.1.3 从 eye space 到 project and clip space<br>
>
> ### 2.2 Primitive Assembly && Triangle setup <br>
> ### 2.3 光栅化阶段<br>
>
>> #### 2.3.1 Rasterization<br>
>> #### 2.3.2 Pixel Operation<br>
>
> ### 2.4 图形硬件<br>
>
>> #### 2.4.1 GPU 内存架构<br>
>> #### 2.4.2 Z Buffer 与 Z 值<br>
>> #### 2.4.3 Stencil Buffer<br>
>> #### 2.4.4 Frame Buffer<br>
>
> ### 2.5 本章小结<br>
## [第3章 Shader Language](https://github.com/yungangwang/Study-Notes/blob/master/Content/%E3%80%8AGPU%20%E7%BC%96%E7%A8%8B%E4%B8%8E%20CG%20%E8%AF%AD%E8%A8%80%E4%B9%8B%E9%98%B3%E6%98%A5%E7%99%BD%E9%9B%AA%E4%B8%8B%E9%87%8C%E5%B7%B4%E4%BA%BA%E3%80%8B/%E3%80%8A%E7%AC%AC03%E7%AB%A0%20%20Shader%20Language%E3%80%8B.md)
> ### 3.1 Shader Language 原理<br>
> ### 3.2 Vertex Shader Program<br>
> ### 3.3 Fragment Shader Program<br>
> ### 3.4 CG VS GLSL VS HLSL<br>
> ### 3.5 本章小结<br>
## [第4章 CG 语言概述]()
> ### 4.1 开始 CG 之旅<br>
> ### 4.2 CG 特性<br>
> ### 4.3 CG 编译<br>
>
>> #### 4.3.1 CG 编译原理<br>
>> #### 4.3.2 CGC 编译命令<br>
>
> ### 4.4 Cg Profiles<br>
## [第5章 CG 数据类型]()
> ### 5.1 基本数据类型<br>
> ### 5.2 数组类型<br>
> ### 5.3 结构类型<br>
> ### 5.4 接口（Interfaces）类型<br>
> ### 5.5 类型转换<br>
## [第6章 CG 表达式与控制语句]()
> ### 6.1 关系操作符（Comparison Operators）<br>
> ### 6.2 逻辑操作符（Logical Operators）<br>
> ### 6.3 数学操作符（Math Operators）<br>
> ### 6.4 移位操作符（Interfaces）类型<br>
> ### 6.5 Swizzle 操作符<br>
> ### 6.6 条件操作符（Conditonal Operators）<br>
> ### 6.7 操作符优先顺序<br>
> ### 6.8 控制流语句（Control Flow Statement）<br>
## [第7章 输入\输出与语义绑定]()
> ### 7.1 CG 关键字<br>
> ### 7.2 uniform<br>
> ### 7.3 const<br>
> ### 7.4 输入\输出修饰符（in\out\inout）<br>
> ### 7.5 语义词（Semantic）与语义绑定（Binding Semantics）<br>
>
>> #### 7.5.1 输入语义与输入语义的区别<br>
>> #### 7.5.2 顶点着色程序的输入语义<br>
>> #### 7.5.3 顶点着色程序的输出语义<br>
>> #### 7.5.4 片段着色程序的输出语义<br>
>> #### 7.5.5 语义绑定方法<br>
>
## [第8章 函数与程序设计]()
> ### 8.1 函数<br>
>
>> #### 8.1.1 数组形参<br>
>
> ### 8.2 函数重载<br>
> ### 8.3 入口函数<br>
> ### 8.4 CG标准函数库<br>
>
>> #### 8.4.1 数学函数（Mathematical Functions）<br>
>> #### 8.4.2 几何函数（Geometric Functions）<br>
>> #### 8.4.3 纹理映射函数（Texture Map Functions）<br>
>> #### 8.4.4 偏导函数（Derivative Functions）<br>
>> #### 8.4.5 调试函数（Debugging Functions）<br>
>
> ### 8.5 在未来将被解决的问题<br>
> ### 开篇语<br>
## [第9章 经典光照模型（illumination model）]()
> ### 9.1 光源<br>
> ### 9.2 漫反射与 Lambert 模型<br>
>
>> #### 9.2.1 漫反射渲染<br>
>
> ### 9.3 镜面反射与 Phong 模型<br>
>
>> #### 9.3.1 phong 模型渲染<br>
>
> ### 9.4 Blinn-Phong 光照模型<br>
> ### 9.5 全局光照模型与 Rendering Equation<br>
> ### 9.6 本章小结<br>
## [第10章 高级光照模型]()
> ### 10.1 Cook-Torrance 光照模型<br>
>
>> #### 10.1.1 Cook-Torrance 光照模型渲染实现<br>
>
> ### 10.2 BRDF 光照模型<br>
>
>> #### 10.2.1 什么是 BRDF 光照模型<br>
>> #### 10.2.2 什么是各向异性<br>
>
> ### 10.3 Bank BRDF 经典模型<br>
> ### 10.4 本章小结<br>
## [第11章 透明光照模型与环境贴图]()
> ### 11.1 Snell 定律与 Fresnel 定律<br>
>
>> #### 11.1.1 折射率与 Snell 定律<br>
>> #### 11.1.2 色散<br>
>> #### 11.1.3 Fresnel 定律<br>
>
> ### 11.2 环境贴图<br>
> ### 11.3 简单透明光照模型<br>
> ### 11.4 复杂透明光照模型与次表面散射<br>
## [第12章 投影纹理映射（Projective Texture Mapping）]()
> ### 12.1 投影纹理映射的优点<br>
> ### 12.2 齐次纹理坐标（Homogeneous Texture Coordinates）<br>
> ### 12.3 原理与实现流程<br>
> ### 12.4 本章小结<br>
## [第13章 Shadow Map]()
> ### 13.1 什么是 depth map<br>
> ### 13.2 Shadow Map 与 Shadow Texture 的区别<br>
> ### 13.3 Shadow Map 原理与实现流程<br>
## [第14章 体绘制（Volume Rendering）概述]()
> ### 14.1 体绘制与科学可视化<br>
> ### 14.2 体绘制应用领域<br>
> ### 14.3 体绘制光照模型<br>
> ### 14.4 体数据（Volume Data）<br>
>
>> #### 14.4.1 体素（Voxel）<br>
>> #### 14.4.2 体纹理（Volume Texture）<br>
>
> ### 14.5 体绘制算法<br>
## [第15章 光线投射算法（Ray Casting）]()
> ### 15.1 光线投射算法原理<br>
>
>> #### 15.1.1 吸收模型<br>
>
> ### 15.2 光线投射算法若干细节之处<br>
>
>> #### 15.2.1 光线如何穿越体纹理<br>
>> #### 15.2.2 透明度、合成<br>
>> #### 15.2.3 沿射线进行采样<br>
>> #### 15.2.4 如何判断光线投射出体纹理<br>
>
> ### 15.3 算法流程<br>
> ### 15.4 光线投射算法实现<br>
> ### 15.5 本章小结<br>
> ### 附录 A： 齐次坐标<br>
> ### 附录 B： 体绘制的医学历程<br>
> ### 附录 C： 模版阴影（Stencil Shadow）<br>
## [参考文献]()
