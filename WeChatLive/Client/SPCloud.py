import ctypes
import os
import sys

def load_spcloud_dll():
    dll_name = "SPCloud.dll"
    
    # 检查PyInstaller的临时路径
    if hasattr(sys, "_MEIPASS"):
        bundle_dir = sys._MEIPASS
    else:
        bundle_dir = os.path.dirname(os.path.abspath(__file__))

    dll_path = os.path.join(bundle_dir, dll_name)

    # 如果DLL未找到, 尝试从exe同级目录加载
    if not os.path.exists(dll_path):
        dll_path = os.path.abspath(os.path.join(os.path.dirname(sys.executable), dll_name))

    if not os.path.exists(dll_path):
        raise FileNotFoundError(f"Could not find the DLL: {dll_path}")

    spcloud_dll = ctypes.CDLL(dll_path)
    return spcloud_dll

try:
    spcloud_dll = load_spcloud_dll()
except FileNotFoundError as e:
    print(f"Initialization error: {e}")
    sys.exit(1)

# 定义InitializeCloud函数
initialize_cloud = spcloud_dll.InitializeCloud
initialize_cloud.argtypes = [ctypes.c_int, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_int, ctypes.POINTER(ctypes.c_int)]
initialize_cloud.restype = ctypes.c_bool

# CloudOffline
cloud_Offline = spcloud_dll.CloudOffline
cloud_Offline.argtypes = [ctypes.POINTER(ctypes.c_int)]
cloud_Offline.restype = ctypes.c_bool

# 定义GetCardExpiredTimeStamp函数
get_card_expired_time_stamp = spcloud_dll.GetCardExpiredTimeStamp
get_card_expired_time_stamp.argtypes = [ctypes.POINTER(ctypes.c_int)]
get_card_expired_time_stamp.restype = ctypes.c_int64

def InitializeCloud(card):
    timeout = 30000  # 超时时间
    ip = "121.40.96.47".encode('utf-8')  # IP地址
    port = 8896  # 端口号
    error_code = ctypes.c_int()
    try:
        result = initialize_cloud(timeout, card.encode('utf-8'), ip, port, ctypes.byref(error_code))
        if result:
            print("云计算初始化成功")
        else:
            print(f"云计算初始化失败，错误码: {error_code.value}")
    except Exception as e:
        print(f"Exception during cloud initialization: {e}")

def CloudOffline():
    error_code = ctypes.c_int()
    try:
        result = cloud_Offline(ctypes.byref(error_code))
        if result:
            print("SP退出成功")
        else:
            print(f"SP退出失败，错误码: {error_code.value}")
    except Exception as e:
        print(f"Exception during cloud offline: {e}")

def GetExpiredTimeStamp():
    error_code = ctypes.c_int()
    expired_datetime = 0
    try:
        expired_time_stamp = get_card_expired_time_stamp(ctypes.byref(error_code))
        if expired_time_stamp != 0:
            from datetime import datetime
            expired_datetime = datetime.utcfromtimestamp(expired_time_stamp)
            return expired_datetime.strftime('%Y年%m月%d日 %H:%M:%S')
        else:
            return 0
    except Exception as e:
        print(f"Exception during fetching expired timestamp: {e}")
        return 0

if __name__ == "__main__":
    card = "ZK534435871A114F44B30D2F34450F53C1"
    InitializeCloud(card)
    print("过期时间:", GetExpiredTimeStamp())
