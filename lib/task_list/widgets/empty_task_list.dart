import 'package:flutter_empty_state/flutter_empty_state.dart';
import 'package:flutter/material.dart';


class EmptyState extends StatelessWidget {
  const EmptyState({super.key});
  @override
  Widget build(BuildContext context) {
    return
    //   debugShowCheckedModeBanner: false,
      Scaffold(
        appBar: AppBar(
          title: Text('Empty widget Flutter'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: EmptyWidget(
            image: null, 
            packageImage: PackageImage.Image_2 , 
            title: 'No Tasks', 
            subTitle: 'No  task added yet',
            titleTextStyle: TextStyle(
              fontSize: 22,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
            subtitleTextStyle: TextStyle(
              fontSize: 14,
              color: Colors.orange,
            ),
          ),
        ),
      );
    
  }
}