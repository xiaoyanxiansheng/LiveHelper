import sys

def cleanup():
    # 清理操作
    print("Cleaning up...")

def main_application_logic():
    # 主要的应用程序逻辑
    print("Running application...")
    raise Exception("Simulated exception")  # 模拟异常

try:
    # 注册退出时的清理回调函数
    # 注：这种方式只在异常退出时才能执行，正常退出时无法执行
    sys.exitfunc = cleanup

    # 执行主要的应用程序逻辑
    main_application_logic()

except Exception as e:
    print(f"Exception occurred: {e}")

finally:
    # 手动调用清理函数，无论是正常退出还是异常退出都会执行
    cleanup()
