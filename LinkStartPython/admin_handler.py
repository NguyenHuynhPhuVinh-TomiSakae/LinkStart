import win32gui
import win32con
import pyautogui
import time

def find_admin_window():
    target_window = None
    
    def window_enum_handler(hwnd, result):
        nonlocal target_window
        if win32gui.IsWindowVisible(hwnd):
            class_name = win32gui.GetClassName(hwnd)
            window_text = win32gui.GetWindowText(hwnd)
            if (class_name == "WindowsForms10.Window.8.app.0.141b42a_r8_ad1" and 
                window_text == "Quản Trị"):
                target_window = hwnd
        return True
    
    win32gui.EnumWindows(window_enum_handler, None)
    return target_window

def get_admin_coordinates(hwnd):
    left, top, right, bottom = win32gui.GetWindowRect(hwnd)
    window_width = right - left
    window_height = bottom - top
    
    # Cập nhật tọa độ tương đối cho menu và nút thêm
    coordinates = {
        'menu_sanpham': (left + (window_width * 0.054), top + (window_height * 0.079)),  # Điều chỉnh tọa độ menu sản phẩm
        'btn_them': (left + (window_width * 0.073), top + (window_height * 0.127)),      # Điều chỉnh tọa độ nút thêm
    }
    
    return {k: (int(x), int(y)) for k, (x, y) in coordinates.items()}

def handle_admin_actions():
    admin_window = find_admin_window()
    if not admin_window:
        print("Không tìm thấy cửa sổ Quản Trị!")
        return False
        
    # Kích hoạt cửa sổ
    win32gui.ShowWindow(admin_window, win32con.SW_RESTORE)
    time.sleep(0.5)
    win32gui.SetForegroundWindow(admin_window)
    time.sleep(0.5)
    
    # Lấy tọa độ các phần tử
    coordinates = get_admin_coordinates(admin_window)
    
    try:
        # Click vào menu sản phẩm
        pyautogui.click(coordinates['menu_sanpham'])
        time.sleep(0.5)
        
        # Click vào nút thêm
        pyautogui.click(coordinates['btn_them'])
        time.sleep(0.5)
        
        return True
        
    except Exception as e:
        print(f"Lỗi khi xử lý form quản trị: {str(e)}")
        return False

if __name__ == "__main__":
    if handle_admin_actions():
        print("Xử lý form quản trị thành công")
    else:
        print("Có lỗi khi xử lý form quản trị") 