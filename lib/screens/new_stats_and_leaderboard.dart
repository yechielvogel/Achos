// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../widgets/leader_board.dart';
// import '../widgets/new_user_stats.dart';

// class BottomSheetPage extends StatefulWidget {
//   @override
//   _BottomSheetPageState createState() => _BottomSheetPageState();
// }

// class _BottomSheetPageState extends State<BottomSheetPage> {
//   PageController _pageController = PageController(initialPage: 0);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onVerticalDragDown: (_) {},
//       child: DraggableScrollableSheet(
//         expand: false,
//         maxChildSize: 0.8,
//         minChildSize: 0.25,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return PageView(
//             controller: _pageController,
//             children: [
//               UserStats(),
//               LeaderBoard(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
