# 基于dotnet6.0运行环境的基础镜像，指定平台和别名
FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/runtime:6.0 AS runner

# 设置工作目录
WORKDIR /server

# 拷贝地图文件
COPY world.wld .

# 安装必要工具，下载并安装TShock
RUN apt-get update \
 && apt-get install -y wget unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && wget -O ./TShock.zip https://github.com/Pryaxis/TShock/releases/download/v5.2.0/TShock-5.2-for-Terraria-1.4.4.9-linux-x64-Release.zip \
 && unzip TShock.zip \
 && rm TShock.zip \
 && tar -xvf TShock-Beta-linux-x64-Release.tar \
 && rm TShock-Beta-linux-x64-Release.tar \
 && rm TShock.Installer

# 定义挂载点，用于映射配置、世界和插件目录
VOLUME ["/tshock", "/worlds", "/plugins"]

# 指定容器监听端口，7878是restapi端口
EXPOSE 7777 7878

# 配置启动命令
ENTRYPOINT [ \
  "./TShock.Server", \
  "-configpath", "/tshock", \
  "-logpath", "/tshock/logs", \
  "-crashdir", "/tshock/crashes", \
  "-worldselectpath", "/worlds", \
  "-additionalplugins", "/plugins" \
]