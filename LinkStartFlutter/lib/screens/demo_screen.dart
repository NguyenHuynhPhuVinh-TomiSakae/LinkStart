import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../services/firebase_service.dart';
import 'demo_control_screen.dart';

class DemoScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.getTechAppBar('Chạy Demo'),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: AppStyles.backgroundGradient),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: GridPainter()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppStyles.buildTechButton(
                        'Chuyển Demo',
                        Icons.play_circle,
                        () async {
                          try {
                            await _firebaseService.updateScreenValue('demo');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DemoControlScreen(),
                              ),
                            );
                            AppStyles.showTopSnackBar(
                                context, 'Đã chuyển sang chế độ Demo');
                          } catch (e) {
                            AppStyles.showTopSnackBar(
                              context,
                              'Lỗi: Không thể chuyển chế độ',
                              isError: true,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      AppStyles.buildTechButton(
                        'Chuyển Slide',
                        Icons.slideshow,
                        () async {
                          try {
                            await _firebaseService.updateScreenValue('slide');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã chuyển sang chế độ Slide'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Lỗi: Không thể chuyển chế độ'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
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
      ),
    );
  }
}
