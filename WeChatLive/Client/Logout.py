import sys
import os
from datetime import datetime

class Consoler:
    def __init__(self):
        self.original_stdout = sys.stdout  # 保存原始的 sys.stdout
        self.console = None

    def init(self, path):
        # path 是日志存储目录的目录路径，不是文件路径
        # 通过当前日期生成日志文件名
        self.now = datetime.now().strftime("%Y-%m-%d")
        self.console_folder = path
        # path 是否存在
        if not os.path.exists(path):
            os.makedirs(path)
        # 日志文件路径
        console_path = os.path.join(path, f"{self.now}.log")
        # 日志文件，我建议是 utf-8 打开，不然可能会有乱码问题
        self.console = open(console_path, "a", encoding="utf-8")

    # 检查当前日期是否和控制台日志文件名一致
    def __check_file_name(func):
        """装饰器，判断是否需要根据日期对控制台输出进行分片存储"""

        def wrapper(self, *args, **kwargs):
            now = datetime.now().strftime("%Y-%m-%d")
            # 检测now是否和self.now一致
            if now != self.now:
                self.now = now
                if hasattr(self, "console") and not self.console.closed:
                    self.console.close()
                self.console = open(os.path.join(self.console_folder, self.now + ".log"), "a", encoding="utf-8")
            return func(self, *args, **kwargs)

        return wrapper

    @__check_file_name
    def write(self, message):
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]  # 精确到毫秒
        if message.strip():  # 只在消息不为空时添加时间戳
            log_message = f"{timestamp} - {message}"
        else:
            log_message = message
        if self.original_stdout:
            self.original_stdout.write(log_message)  # 先写入原始 sys.stdout，即输出到控制台
            self.original_stdout.flush()
        if self.console:
            self.console.write(log_message)
            self.console.flush()

    def flush(self):
        if self.original_stdout:
            self.original_stdout.flush()
        if self.console:
            self.console.flush()

if __name__ == "__main__":
    # 创建 Consoler 实例并初始化日志路径
    logger = Consoler()
    logger.init("logs")

    # 重定向 sys.stdout 和 sys.stderr 到 Consoler 实例
    sys.stdout = logger
    sys.stderr = logger

    # 测试输出
    print("This is a test message.")
    print("This message will be written to both console and log file.")
    print("This message will be written to both console and log file2.")



logger = Consoler()
logger.init("Logs")

# 重定向 sys.stdout 到 Consoler 实例
sys.stdout = logger
sys.stderr = logger  # 如果需要也重定向 stderr
