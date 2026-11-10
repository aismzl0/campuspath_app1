# 导入蓝图类和JSON响应工具
from flask import Blueprint,jsonify


# 创建系统接口蓝图，名字叫system
system_bp = Blueprint('system',__name__)

# 健康检查接口：GET请求，路径为/health
@system_bp.route('/health',methods=['GET'])
def health_check():
    # 返回JSON格式的统一响应
    return jsonify({
        'code':0,
        'message':'success',
        'data':{
            'status':'ok',
            'service':'campuspath-backend'
        }
    })