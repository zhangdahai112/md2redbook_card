# 使用官方Node.js镜像作为基础镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制package.json和pnpm-lock.yaml(如果存在)
COPY package.json pnpm-lock.yaml* ./

# 安装pnpm
RUN npm install -g pnpm


# 复制项目文件
COPY . .

# 安装项目依赖
RUN pnpm install

# 修改Vite配置以监听所有网络接口
ENV HOST=0.0.0.0
# 暴露5173端口(Vite默认端口)
EXPOSE 5173

# 启动开发服务器
CMD ["pnpm", "run", "dev", "--host"]