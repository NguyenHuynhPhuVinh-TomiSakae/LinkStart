import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../services/firebase_service.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String expandedMenu = '';

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: TextStyle(color: Colors.white70)),
      onTap: onTap,
    );
  }

  Widget _buildExpandableMenu(
      String title, IconData icon, List<Map<String, dynamic>> subMenus) {
    bool isExpanded = expandedMenu == title.toLowerCase();
    String firebaseValue = title
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('ả', 'a')
        .replaceAll('ý', 'y')
        .replaceAll('ứ', 'u');

    return Container(
      decoration: AppStyles.getTechContainerDecoration(),
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                expandedMenu = isExpanded ? '' : title.toLowerCase();
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(color: AppStyles.accentColor.withOpacity(0.3), height: 1),
            ...subMenus.map((menu) => _buildMenuItem(
                  menu['title'],
                  menu['icon'],
                  () async {
                    try {
                      await _firebaseService
                          .updateScreenValue('$firebaseValue-${menu['value']}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã chuyển đến ${menu['title']}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Lỗi: Không thể chuyển đến ${menu['title']}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                )),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppStyles.getTechAppBar('Quản Trị'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppStyles.backgroundGradient,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: GridPainter()),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildExpandableMenu(
                      'Quản Lý',
                      Icons.manage_accounts,
                      [
                        {
                          'title': 'Sản Phẩm',
                          'icon': Icons.inventory_2,
                          'value': 'sanpham'
                        },
                        {
                          'title': 'Nhân Viên',
                          'icon': Icons.people,
                          'value': 'nhanvien'
                        },
                        {
                          'title': 'Khách Hàng',
                          'icon': Icons.person,
                          'value': 'khachhang'
                        },
                        {
                          'title': 'Tài Khoản',
                          'icon': Icons.account_circle,
                          'value': 'taikhoan'
                        },
                        {
                          'title': 'Nhà Cung Cấp',
                          'icon': Icons.local_shipping,
                          'value': 'nhacungcap'
                        },
                      ],
                    ),
                    SizedBox(height: 8),
                    _buildExpandableMenu(
                      'Tra Cứu',
                      Icons.search,
                      [
                        {
                          'title': 'Sản Phẩm',
                          'icon': Icons.inventory_2,
                          'value': 'sanpham'
                        },
                        {
                          'title': 'Nhân Viên',
                          'icon': Icons.people,
                          'value': 'nhanvien'
                        },
                        {
                          'title': 'Khách Hàng',
                          'icon': Icons.person,
                          'value': 'khachhang'
                        },
                        {
                          'title': 'Tài Khoản',
                          'icon': Icons.account_circle,
                          'value': 'taikhoan'
                        },
                      ],
                    ),
                    SizedBox(height: 8),
                    AppStyles.buildTechButton(
                      'Tính Toán',
                      Icons.calculate,
                      () async {
                        try {
                          await _firebaseService.updateScreenValue('tinhtoan');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã chuyển đến Tính Toán')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Lỗi: Không thể chuyển đến Tính Toán'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    AppStyles.buildTechButton(
                      'Thống Kê',
                      Icons.bar_chart,
                      () async {
                        try {
                          await _firebaseService.updateScreenValue('thongke');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã chuyển đến Thống Kê')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Lỗi: Không thể chuyển đến Thống Kê'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    AppStyles.buildTechButton(
                      'Báo Biểu',
                      Icons.assessment,
                      () async {
                        try {
                          await _firebaseService.updateScreenValue('baobieu');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã chuyển đến Báo Biểu')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Lỗi: Không thể chuyển đến Báo Biểu'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    AppStyles.buildTechButton(
                      'Lập Hóa Đơn',
                      Icons.receipt_long,
                      () async {
                        try {
                          await _firebaseService.updateScreenValue('laphoadon');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Đã chuyển đến Lập Hóa Đơn')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Lỗi: Không thể chuyển đến Lập Hóa Đơn'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    AppStyles.buildTechButton(
                      'Nhập Sản Phẩm',
                      Icons.add_shopping_cart,
                      () async {
                        try {
                          await _firebaseService
                              .updateScreenValue('nhapsanpham');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Đã chuyển đến Nhập Sản Phẩm')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Lỗi: Không thể chuyển đến Nhập Sản Phẩm'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
