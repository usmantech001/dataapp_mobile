// SizedBox(
//   height: 200,
//   child: GestureDetector(
//     onTap: () {
//       setState(() {
//         isFront = !isFront;
//       });
//     },
//     child: AnimatedSwitcher(
//       duration: const Duration(milliseconds: 600),
//       switchInCurve: Curves.easeInOut,
//       switchOutCurve: Curves.easeInOut,
//       transitionBuilder: (Widget child, Animation<double> animation) {
//         return AnimatedBuilder(
//           animation: animation,
//           builder: (context, childWidget) {
//             final rotate = Tween(begin: pi, end: 0.0).animate(animation);
//             return Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.rotationY(rotate.value),
//               child: childWidget,
//             );
//           },
//           child: child,
//         );
//       },
//       child: isFront
//           ? _buildCardFront().withKey(ValueKey('frontCard'))
//           : _buildCardBack().withKey(ValueKey('backCard')),
//     ),
//   ),
// ),


// extension WithKey on Widget {
//   Widget withKey(Key key) => KeyedSubtree(key: key, child: this);
// }
