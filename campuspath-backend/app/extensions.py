# 导入SQLAlchemy数据库ORM
from flask_sqlalchemy import SQLAlchemy
# 导入数据库迁移工具
from flask_migrate import Migrate

# 创建数据库实例，先不绑定应用，在工厂函数里再绑定
db = SQLAlchemy()
#创建迁移工具实例
migrate = Migrate()