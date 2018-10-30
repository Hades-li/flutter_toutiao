# flutter_toutiao

一个低仿今日头条的应用（纯粹为了学习flutter）


## Getting Started

1. 安装插件 pub get;

2. 执行`flutter packages pub run build_runner build`构建json序列化模型(json_serializable);

3. 接口直接改为调用m.toutiao.com的接口。可惜没有办法破解接口请求参数，导致同类型新闻在短时间内刷新或者加载，内容都不会变化。


## 更新说明
0.1的版本更新为采用tabBar的切换方式。可惜造成了第三方下拉插件出现bug。

![image](https://github.com/Hades-li/flutter_toutiao/blob/0.1/demo.gif)

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).


