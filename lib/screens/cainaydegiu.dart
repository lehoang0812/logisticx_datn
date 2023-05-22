// Scaffold(
//       body: SingleChildScrollView(
//         padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 50,
//             ),
//             Image(image: AssetImage('./assets/ic_logo.png'), fit: BoxFit.cover),
//             SizedBox(
//               height: 100,
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Navigator();
//                   },
//                   child: Text(
//                     'Bắt đầu tạo đơn',
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.orange),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(6))))),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );