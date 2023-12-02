# mkdocs 安装

#### 安装 mkdocs

```bash
$ pip install mkdocs
```

报错：`AttributeError: module 'lib' has no attribute 'X509_V_FLAG_CB_ISSUER_CHECK'`

由于库文件冲突导致的安装失败，删除后重新安装并更新

```bash
$ sudo rm -rf /usr/lib/python3/dist-packages/OpenSSL
$ sudo pip3 install pyopenssl
$ sudo pip3 install pyopenssl --upgrade
```

安装成功

#### 创建项目

```bash
$ mkdocs new my-project
```

报错：`zsh: command not found`

因为装了 zsh 插件导致配置不太一样，路径可能没通过来，就切回 bash 使用

切换 `bash` 和 `zsh`

``` bash
$ chsh -s /bin/bash
```

成功显示