# 导入蓝图类、JSON响应工具、请求对象
from flask import Blueprint,jsonify,request
# 导入数据库实例和POI模型
from app.extensions import db
from app.models.poi import Poi


# 创建POI接口蓝图，名字叫poi
poi_bp = Blueprint('poi',__name__)

# 搜索地点接口：GET请求，路径为/search
@poi_bp.route('/search',methods=['GET'])
def search_poi():
    # 从url参数中获取搜索关键词，默认空字符串
    keyword = request.args.get('keyword','').strip()


    # 查询语句：query查询Poi表
    query = Poi.query


    # 如果关键词不为空，就做模糊匹配
    if keyword:
        # 模糊查询：名称包含关键词，或者别名包含关键词
        # like是SQL的模糊匹配语法，%代表任意字符
        query = query.filter(
            db.or_(
                Poi.name.like(f'%{keyword}%'),
                Poi.aliases.like(f'%{keyword}%')
            )
        )


    # 执行查询，最多返回20条结果
    poi_list = query.limit(20).all()

    # 把每条数据都转成字典，组成列表
    data = [poi.to_dict() for poi in poi_list]

    # 返回统一格式的JSON响应
    return jsonify({
        'code':0,
        'message':'success',
        'data':data
    })