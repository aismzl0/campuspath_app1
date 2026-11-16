# 导入应用工厂函数和数据库实例
from app import create_app
from app.extensions import db
from app.models.poi import Poi

# 创建应用
app = create_app()

# 在应用上下文中操作数据库
with app.app_context():
    # 准备5条测试地点数据，对应前端的假数据
    test_places = [
        Poi(name='思齐楼', aliases='一号教学楼', latitude=39.9042, longitude=116.4074, address='校园东区', description='主要教学楼'),
        Poi(name='格物楼', aliases='二号教学楼', latitude=39.9082, longitude=116.4094, address='校园西区', description='理科实验楼'),
        Poi(name='图书馆', aliases='图书馆', latitude=39.9062, longitude=116.4084, address='校园中心', description='校图书馆'),
        Poi(name='体育馆', aliases='操场', latitude=39.9092, longitude=116.4064, address='校园北区', description='室内体育馆'),
        Poi(name='第一教学楼', aliases='一教', latitude=39.9032, longitude=116.4104, address='校园南区', description='公共教学楼'),
    ]

    # 批量添加到数据库
    db.session.add_all(test_places)
    # 提交保存
    db.session.commit()
    print('测试数据插入成功')