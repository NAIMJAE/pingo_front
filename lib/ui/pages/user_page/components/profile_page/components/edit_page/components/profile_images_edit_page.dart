import 'package:flutter/material.dart';

class ProfileImagesEditPage extends StatefulWidget {
  const ProfileImagesEditPage({super.key});

  @override
  State<ProfileImagesEditPage> createState() => _ProfileImagesEditPageState();
}

class _ProfileImagesEditPageState extends State<ProfileImagesEditPage> {
  List<bool> hasImages = [true, true, true, false, false];

  void _toggleImage(int index) {
    setState(() {
      hasImages[index] = !hasImages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              _mainImage(),
              for (int i = 0; i < hasImages.length; i++) _subImage(context, i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainImage() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://picsum.photos/200/100',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '대표',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _subImage(BuildContext context, int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: hasImages[index]
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://picsum.photos/200/100',
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _toggleImage(index),
                    ),
                  ),
                ),
        ),
        if (hasImages[index])
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('대표이미지로 지정'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _toggleImage(index);
                                  Navigator.of(context).pop();
                                },
                                child: Text('삭제'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
