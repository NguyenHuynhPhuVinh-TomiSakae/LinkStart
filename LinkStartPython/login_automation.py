import win32gui
import win32con
import time
import pyautogui

def bring_app_to_front():
    target_window = None
    
    def window_enum_handler(hwnd, result):
        nonlocal target_window
        if win32gui.IsWindowVisible(hwnd):
            class_name = win32gui.GetClassName(hwnd)
            if class_name == "WindowsForms10.Window.20008.app.0.141b42a_r8_ad1":
                target_window = hwnd
        return True
    
    win32gui.EnumWindows(window_enum_handler, None)
    return target_window

def get_window_coordinates(hwnd):
    left, top, right, bottom = win32gui.GetWindowRect(hwnd)
    window_width = right - left
    window_height = bottom - top
    
    return {
        'username': (int(left + window_width * 0.487), int(top + window_height * 0.442)),
        'password': (int(left + window_width * 0.509), int(top + window_height * 0.571)),
        'login': (int(left + window_width * 0.471), int(top + window_height * 0.713))
    }

def perform_login():
    window_handle = bring_app_to_front()
    if not window_handle:
        print("Không tìm thấy cửa sổ ứng dụng!")
        return False
        
    win32gui.ShowWindow(window_handle, win32con.SW_RESTORE)
    time.sleep(0.5)
    win32gui.SetForegroundWindow(window_handle)
    time.sleep(0.5)
    
    coordinates = get_window_coordinates(window_handle)
    
    pyautogui.click(coordinates['username'])
    pyautogui.typewrite('admin')
    time.sleep(0.5)
    
    pyautogui.click(coordinates['password'])
    pyautogui.typewrite('123456')
    time.sleep(0.5)
    
    pyautogui.click(coordinates['login'])
    return True

if __name__ == "__main__":
    if perform_login():
        print("Đăng nhập thành công!")
    else:
        print("Đăng nhập thất bại!") 