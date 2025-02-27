import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/community_model/place_review.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class PlaceBox extends StatefulWidget {
  final PlaceReview placeReview;
  final Function changePlaceShared;

  const PlaceBox(this.placeReview, this.changePlaceShared, {super.key});
  @override
  State<PlaceBox> createState() => _PlaceBoxState();
}

class _PlaceBoxState extends State<PlaceBox> {
  bool isExpanded = false; // 상태 유지

  @override
  void didUpdateWidget(covariant PlaceBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.placeReview != oldWidget.placeReview) {
      setState(() {
        isExpanded = false; // 부모에서 placeReview 변경 시 자동 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
        curve: Curves.easeInOut, // 부드러운 애니메이션 효과
        margin: EdgeInsets.only(bottom: 8.0),
        width: totalWidth * 0.9,
        height: isExpanded
            ? totalWidth * 0.9 / 16 * 11
            : totalWidth * 0.9 / 16 * 7, // 확장/축소 높이
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CustomImage().provider(widget.placeReview.thumb!),
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 아이콘
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.thumb_up, size: 20, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.changePlaceShared(true, widget.placeReview);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.ios_share_outlined,
                        size: 20, color: Colors.white),
                  ),
                )
              ],
            ),
            // 하단 정보 (애니메이션 적용)
            Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, // 아래쪽이 진하게
                  end: Alignment.topCenter, // 위쪽이 투명하게
                  colors: [
                    Colors.black.withOpacity(0.8), // 아래쪽 (진한 검은색)
                    Colors.black.withOpacity(0.6), // 중간 (반투명)
                    Colors.black.withOpacity(0.0), // 위쪽 (완전 투명)
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.placeReview.placeName!,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    widget.placeReview.addressName!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  // ✅ 추가 정보 (애니메이션 적용)
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInExpo,
                    opacity: isExpanded ? 1.0 : 0.0, // 클릭 시 투명도 조절
                    child: Visibility(
                      visible: isExpanded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            "🏷 ${widget.placeReview.userNick}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            "💬 ${widget.placeReview.contents}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
