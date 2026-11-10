# 配置类：所有环境配置都写在这里
class Config:
    # 数据库地址：先用SQLite本地文件数据库，不用装PostgreSQL，入门先跑通
    # 原项目用PostgreSQL+PostGIS，后面我们再升级替换
    SQLALCHEMY_DATABASE_URI = 'sqlite:///campuspath.db'
    # 关闭追踪对象修改，减少内存开销，官方建议关闭
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # 服务端口
    PORT = 8080

