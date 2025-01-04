import time
import win32gui
import win32con

def close_active_window():
    # Lấy handle của cửa sổ đang active
    hwnd = win32gui.GetForegroundWindow()
    
    if hwnd:
        try:
            # Gửi message WM_CLOSE để đóng cửa sổ
            win32gui.PostMessage(hwnd, win32con.WM_CLOSE, 0, 0)
            return True
        except:
            return False
    return False

if __name__ == "__main__":
    if close_active_window():
        print("Đã đóng cửa sổ thành công!")
    else:
        print("Không thể đóng cửa sổ!") 