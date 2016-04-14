
[反编译 - 环境搭建](http://www.jianshu.com/p/ca32e2547270)


[VolleyDemo](https://github.com/joyin5344/VolleyDemo)


上几章通过封装Volley实现的网络处理框架，做了简单的网络应用。接下来将以此为原型，进入我们的《反编译》系列章节。

> 工欲善其事，必先利其器。

# 工具

该系列章节中使用到的工具 **包括但不限于以下内容**，同时反编译系列的工具也会同代码共享到[https://github.com/joyin5344/Decompiler](https://github.com/joyin5344/Decompiler)上。

- [apktool](https://github.com/iBotPeaches/Apktool)

  > ApkTool是Google提供的APK编译工具，能够反编译及回编译apk，同时安装反编译系统apk所需要的framework-res框架，清理上次反编译文件夹等功能。需要java支持。——百度百科

- signapk

> 实现对安卓ROM和安卓应用进行签名。

- dex2jar

> dex2jar 是一个能操作Android的dalvik(.dex)文件格式和Java的(.class)的工具集合。

- jd-gui

> 绿色、免费的Java反编译工具。

# 环境准备

反编译工具目录结构主要有apktool_sign和jd-gui。

到[github](https://github.com/joyin5344/Decompiler)把资源下载下来，目录结构如下图所示：

![目录结构](http://upload-images.jianshu.io/upload_images/1836004-5af0b2ae2ab84318.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
有兴趣的读者可以按照我后面的方法设置环境。

1. 将`apktool_sign`和`jd-gui-0.3.5.linux.i686`目录copy到~/lib目录下：

![～/lib目录](http://upload-images.jianshu.io/upload_images/1836004-61223f30db1b6ef3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**注意：**如果apktool_sign不是放在~/lib/下，一定要修改`apktool_sign/sign.sh`文件中第六行，将变量`libdir`的值设为脚本所在目录（该脚本在后面用到时再详解）：

```
libdir=~/lib/apktool_sign/
```

2. 创建链接（便于后续在任意路径使用工具）：

```
sudo ln -s ~/lib/apktool_sign/sign.sh /usr/local/bin/apksign
sudo ln -s ~/lib/apktool_sign/apktool /usr/local/bin/apktool
sudo ln -s ~/lib/apktool_sign/dex2jar/dex2jar.sh /usr/local/bin/dex2jar
sudo ln -s ~/lib/jd-gui-0.3.5.linux.i686/jd-gui /usr/local/bin/jd-gui
```

![/usr/local/bin/目录](http://upload-images.jianshu.io/upload_images/1836004-a042d3c5cab91516.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3. framework-res.apk

很多时候我们会忘记安装framework-res.apk，导致操作不成功，对于我们的项目，直接用自己手机里面导出的apk即可。

```
adb pull system/framework/framework-res.apk .
```

安装framework-res，使用如下命令：

```
apktool install-framework framework-res.apk
```

或

```
apktool if framework-res.apk
```

# 测试

正确按照上面的步骤执行，此时便可以进行反编译操作了。

## 源文件

我们先创建目录`~/android/decompile/`，然后将之前VolleyDemo.apk[^VolleyDemo.apk]复制到该目录下。

[^VolleyDemo.apk]: 前面章节代码编译后的成果，同时在`Decompiler`项目中`apks/`路径下。

```
mkdir -p ~/android/decompile/
cp [VolleyDemo.apk路径] ~/android/decompile/
cd !$
```

### decode

apktool反编译apk文件，执行如下命令：

```
apktool d VolleyDemo.apk 
```

![decode输出](http://upload-images.jianshu.io/upload_images/1836004-71e8a51dfb93f133.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![目录结构](http://upload-images.jianshu.io/upload_images/1836004-80801e87abc2af6f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

VolleyDemo/目录下则是反编译后生成的文件，具体内容后续章节会介绍到。

### build

```
apktool b VolleyDemo
```

![build输出](http://upload-images.jianshu.io/upload_images/1836004-3b11832e7ca73a77.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

build后会生成VolleyDemo/dist/VolleyDemo.apk文件，该文件是没经过签名的，也就意味着不能安装使用。

### 签名

通过apksign命令进行签名，具体实现的脚本代码后续介绍。

```
apksign VolleyDemo/dist/VolleyDemo.apk
```

![sign输出](http://upload-images.jianshu.io/upload_images/1836004-592e81311b6b28f5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

最终生成的`VolleyDemo/dist/VolleyDemo.apk_sign.apk`文件就是经过签名，可安装使用的apk。

至此，反编译、回编译、签名，流程已经跑通，后续章节将在此基础上讲解签名脚本，查看源码、进行代码注入等操作。

