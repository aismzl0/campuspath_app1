# 导入Flask核心类
from flask import Flask
# 导入CORS跨域工具
from flask_cors import CORS
# 导入数据库实例和迁移工具
from app.extensions import db, migrate


# 应用工厂函数：创建并配置整个Flask应用
def create_app():
    # 创建Flask应用实例，__name__表示当前模块名
    app = Flask(__name__)


    # 加载配置：从config文件中读取所有配置项
    app.config.from_object('app.config.Config')


    # 初始化数据库：把数据库和应用绑定
    db.init_app(app)
    #初始化数据库迁移工具
    migrate.init_app(app,db)


    # 开启跨域：允许所有来源的前端访问接口，开发阶段方便调试
    CORS(app)


    # 注册蓝图：把各个模块的接口路由注册到应用上
    # 先注册一个测试用的系统接口蓝图，后面逐步添加搜索、导航等模块
    from app.api.system import system_bp
    app.register_blueprint(system_bp,url_prefix='/api/system')


    return app