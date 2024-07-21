import tkinter as tk
from tkinter import messagebox
import requests

def send_request():
    passport = passport_entry.get()
    live_id = live_id_entry.get()
    url = f"http://110.40.38.21:5001/check/unbind-live-room?passport={passport}&live_id={live_id}"
    
    try:
        response = requests.get(url)
        if response.status_code == 200:
            messagebox.showinfo("Success", "解绑成功")
        else:
            messagebox.showerror("Error", f"请求失败，状态码：{response.status_code}")
    except Exception as e:
        result_label.config(text=f"Request failed with error: {str(e)}")

app = tk.Tk()
app.title("解绑直播间")

tk.Label(app, text="卡密:").grid(row=0, column=0, padx=10, pady=5)
passport_entry = tk.Entry(app)
passport_entry.grid(row=0, column=1, padx=10, pady=5)

tk.Label(app, text="解绑直播间:").grid(row=1, column=0, padx=10, pady=5)
live_id_entry = tk.Entry(app)
live_id_entry.grid(row=1, column=1, padx=10, pady=5)

send_button = tk.Button(app, text="解绑", command=send_request)
send_button.grid(row=2, column=0, columnspan=2, pady=10)

result_label = tk.Label(app, text="")
result_label.grid(row=3, column=0, columnspan=2, pady=5)

app.mainloop()
