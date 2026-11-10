# 导入数据库实例，所有模型都用它来定义表
from app.extensions import db


# POI地点表模型类，继承db.Model，对应数据库里的一张表
class Poi(db.Model):
    # 表名：数据库里真实的表名
    __tablename__ = 'pois'

    # 主键id：整数类型，自增主键，每条数据唯一标识
    id = db.Column(db.Integer,primary_key=True,autoinctrment=True)
    # 地点名称：字符串类型，最长50字符，不允许为空，建立索引加快搜索
    name = db.Colum(db.String(50),nullable=False,index=True)
    # 地点别名：字符串类型，多个别名用逗号分隔，可选
    aliases = db.Colum(db.String(200),default='')
    # 纬度：浮点数类型，记录地点的GPS纬度
    latitude = db.Colum(db.Float, nullable=False)
    # 经度：浮点数类型，记录地点的GPS经度
    longitude = db.Column(db.Float, nullable=False)
    # 地点地址：字符串类型，可选
    address = db.Column(db.String(200), default='')
    # 地点简介：文本类型，可选
    description = db.Column(db.Text, default='')


    # 转字典方法：把数据库对象转换成Python字典，方便返回JSON给前端
    def to_dict(self):
        return{
            'id':self.id,
            'name':self.name,
            'aliases':self.aliases,
            'latitude':self.latitude,
            'longitude':self.longitude,
            'address':self.address,
            'description':self.description
        }