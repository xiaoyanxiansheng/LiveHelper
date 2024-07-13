from datetime import datetime
import logging
import os
import sys

if hasattr(sys, '_MEIPASS'):
    current_dir = sys._MEIPASS
else:
    current_dir = os.path.dirname(os.path.abspath(__file__))

log_file_path = os.path.join(current_dir, f"Log/application_{datetime.now().strftime('%Y-%m-%d')}.log")

# 确保目录存在
os.makedirs(os.path.dirname(log_file_path), exist_ok=True)

# 配置日志记录
logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(levelname)s: %(message)s',
                    handlers=[logging.FileHandler(log_file_path),
                              logging.StreamHandler(sys.stdout)])

# 重定向 sys.stdout 和 sys.stderr 到 logging 模块
class LoggerWriter:
    def __init__(self, level):
        self.level = level

    def write(self, message):
        if message != '\n':  # 避免记录空行
            self.level(message)

    def flush(self):  # 需要实现flush方法以满足标准流的接口
        pass

sys.stdout = LoggerWriter(logging.debug)
sys.stderr = LoggerWriter(logging.error)