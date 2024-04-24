
# 使用

### 快速启动
将镜像文件拷贝到服务器，然后执行docker导入指令，例如`tshock-5.2.tar`，镜像导入一次即可。
```shell
docker load -i ./tshock-5.2.tar
```


内置了一张空白地图，启动后会自动加载地图，并开服。
```shell
docker run --name tshock -t \
 -p 7777:7777 \
 -d tshock:5.2 \
 -lang 7 \
 -world world.wld
```


**添加插件**
```shell
# 将当前目录下的WorldModify.dll文件，拷贝到容器的插件目录
docker cp ./WorldModify.dll tshock:/plugins

# 添加完插件后，需要重新开服
docker restart tshock
```

**更换地图**
```shell
# 将当前目录下的world-s1.wld文件，拷贝到容器的地图目录
docker cp ./world-s1.wld tshock:/worlds
```


**修改配置**
先将容器内的配置文件拷出，修改之后，再拷贝到容器。
然后重启服务器。（或者在控制台上执行`/reload` 指令重新加载）
```shell
# 将配置文件拷出
docker cp tshock:/tshock/config.json .

# 将修改后的配置，拷贝到容器
docker cp config.json tshock:/tshock
```


----


### 持久化
成功开服只是第一步，后面还需要管理，添加插件，导出存档之类。此时需要持久化配置。
对于泰拉玩家，一个流程结束后，会再开一个流程。此时更换本地文件即可新开流程。
先上运行代码：
```
docker run --name tshock -t \
 -p 7777:7777 \
 -v /opt/S1/tshock:/tshock \
 -v /opt/S1/worlds:/worlds \
 -v /opt/S1/plugins:/plugins \
 -d tshock:5.2 \
 -lang 7
```

`/opt/S1/` 是你的本机目录，就是将服务器目录映射到docker容器，简单理解就是让容器读取本地的文件。
`/opt/S1/tshock` 是tshock配置目录。
`/opt/S1/worlds` 是地图目录。
`/opt/S1/plugins` 是插件目录，将插件拷到这里就行，而不需要cp到容器内，有时多个服务器插件的情况会不一样。请注意，这个目录下不要有`TShockAPI.dll`，因为tshock自己已加载了该插件。

---

以上仍然是为了快速开服做准备，我们甚至没有在本地创建目录，以及拷贝地图文件。
那我怎么将默认地图更换成自己的呢！
先将你的地图 拷贝到 `/opt/S1/worlds`，并命名为 `world.wld`。
然后执行一下指令：
```
docker run --name tshock -t \
 -p 7777:7777 \
 -v /opt/S1/tshock:/tshock \
 -v /opt/S1/worlds:/worlds \
 -v /opt/S1/plugins:/plugins \
 -d tshock:5.2 \
 -lang 7 \
 -world /worlds/world.wld
```

---

### 再次创建容器
学习阶段，我们会多次创建容器，此时就要关闭或处理上次的容器。
删除容器时，一定要先停止，不然有时会删除失败。
```shell
# 停止容器
docker stop tshock

# 删除容器
docker remove tshock
```



# 开发
`Dockerfile`是镜像打包配置文件，打包时会自动从下载tshock。
```shell
# 打包指令
docker build -t tshock:5.2 .

# 打包指令，mac m1芯片
docker buildx build --platform linux/amd64 -t tshock:5.2 .

# 导出镜像文件（本机，不需要导出，直接启动容器即可）
docker save -o ./tshock-5.2.tar tshock:5.2
```

