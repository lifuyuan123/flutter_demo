import 'package:flutter/material.dart';

/// 登录
class LoginPage extends StatefulWidget {



  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {

  final _controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          //背景图
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            const Positioned(
                top: 80,
                left: 15,
                child: Text(
                  'Welcome\nBack',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                )),
            SingleChildScrollView(
              //类似于ScrollView
              child: Container(
                  padding: EdgeInsets.only(
                      left: 35,
                      right: 35,
                      top: MediaQuery.of(context).size.height * 0.5),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        constraints:
                            const BoxConstraints(maxHeight: 55, minHeight: 55),
                        child: TextField(
                          obscureText: true,
                          onChanged: (v){
                            print('onChage:$v      ${_controller.text}');
                          },
                          controller: _controller,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
