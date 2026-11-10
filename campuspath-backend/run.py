# 从app包中导入创建应用的工厂函数
from app import create_app

# 创建Flask应用实例
app = create_app()

# 程序入口：直接运行这个文件时启动开发服务器
if __name__ == '__main__':
    # debug=True：修改代码后自动重启，开发时开启
    # host='0.0.0.0'：允许局域网内其他设备访问，方便手机真机调试
    app.run(debug=True, host='0.0.0.0', port=8080)