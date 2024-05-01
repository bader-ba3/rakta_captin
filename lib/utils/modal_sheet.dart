// import 'package:flutter/material.dart';
// import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
//
// abstract class ModalSheetUtils{
//   static final pageIndexNotifier = ValueNotifier(0);
//
//   static SliverWoltModalSheetPage page1 (BuildContext modalSheetContext, TextTheme textTheme) {
//     return WoltModalSheetPage(
//       enableDrag: false,
//       hasSabGradient: false,
//       stickyActionBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () => pageIndexNotifier.value = 1,
//               child: const SizedBox(
//                 height: 56.0,
//                 width: double.infinity,
//                 child: Center(child: Text('Go Online')),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => print("no"),
//               child: const SizedBox(
//                 height: 56.0,
//                 width: double.infinity,
//                 child: Center(child: Text('Contact Help')),
//               ),
//             ),
//           ],
//         ),
//       ),
//       topBarTitle: Text('Status', style: textTheme.titleSmall),
//       isTopBarLayerAlwaysVisible: true,
//       child: const Padding(
//         padding: EdgeInsets.fromLTRB(
//           16.0,
//           16.0,
//           16.0,
//           150.0,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             CircleAvatar(radius: 20,backgroundColor: Colors.red,),
//             Text("You are Offline",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
//           ],
//         ),),
//     );
//   }
//   static SliverWoltModalSheetPage page2 (BuildContext modalSheetContext, TextTheme textTheme) {
//     return WoltModalSheetPage(
//       enableDrag: true,
//       hasSabGradient: false,
//       stickyActionBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () => pageIndexNotifier.value = 0,
//               child: const SizedBox(
//                 height: 56.0,
//                 width: double.infinity,
//                 child: Center(child: Text('Go Offline')),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => pageIndexNotifier.value = 2,
//               child: const SizedBox(
//                 height: 56.0,
//                 width: double.infinity,
//                 child: Center(child: Text('Contact Help')),
//               ),
//             ),
//           ],
//         ),
//       ),
//       topBarTitle: Text('Status', style: textTheme.titleSmall),
//       isTopBarLayerAlwaysVisible: true,
//       child: const Padding(
//         padding: EdgeInsets.fromLTRB(
//           16.0,
//           16.0,
//           16.0,
//           150.0,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             CircleAvatar(radius: 20,backgroundColor: Colors.green,),
//             Text("You are Online",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
//           ],
//         ),),
//     );
//   }
//
//   static SliverWoltModalSheetPage page3(BuildContext modalSheetContext, TextTheme textTheme) {
//     return SliverWoltModalSheetPage(
//       pageTitle: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           'Material Colors',
//           style: textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
//         ),
//       ),
//       heroImage: Image(
//         image: NetworkImage(
//           'https://raw.githubusercontent.com/woltapp/wolt_modal_sheet/main/example/lib/assets/images/material_colors_hero_dark.png',
//         ),
//         fit: BoxFit.cover,
//       ),
//       leadingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(16.0),
//         icon: const Icon(Icons.arrow_back_rounded),
//         onPressed: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
//       ),
//       trailingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(16.0),
//         icon: const Icon(Icons.close),
//         onPressed: () {
//           Navigator.of(modalSheetContext).pop();
//           pageIndexNotifier.value = 0;
//         },
//       ),
//       mainContentSlivers: [
//         SliverPadding(
//           padding: const EdgeInsets.all(16.0),
//           sliver: SliverToBoxAdapter(
//             child: TextButton(
//               onPressed: Navigator.of(modalSheetContext).pop,
//               child: const Text('Close'),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }