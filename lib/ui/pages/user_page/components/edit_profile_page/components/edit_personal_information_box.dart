import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/user_model/user_info.dart';
import '../../../../../../data/models/user_model/user_mypage_info.dart';
import 'jop_page/first_job_select_page.dart';
import 'jop_page/second_job_select_page.dart';

class EditPersonalInformationBox extends ConsumerStatefulWidget {
  final UserInfo copyUserInfo;
  const EditPersonalInformationBox(this.copyUserInfo, {super.key});

  @override
  ConsumerState<EditPersonalInformationBox> createState() =>
      _EditPersonalInformationBoxState();
}

class _EditPersonalInformationBoxState
    extends ConsumerState<EditPersonalInformationBox> {
  // 신장
  final TextEditingController heightController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final userInfo = widget.copyUserInfo;

    logger.i(userInfo);
    // 유저 정보가 있을 경우 해당 값을 사용, 없으면 기본값 설정
    // 생년월일
    // 신장
    heightController.text = userInfo.userHeight?.toString() ?? '';

    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '인적사항',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            _buildInformationBox(context, '생년월일', _buildBirthInfo(userInfo)),
            _buildInformationBox(context, '신장', _buildHeightInfo()),
            _buildInformationBox(context, '1차 직종', _build1stJobInfo(userInfo)),
            _buildInformationBox(context, '2차 직종', _build2ndJobInfo(userInfo)),
            _buildInformationBox(context, '거주지', _buildAddressInfo(context)),
            _buildInformationBox(context, '종교', _buildReligionInfo(context)),
            _buildInformationBox(context, '흡연여부', _buildSmokingInfo(context)),
            _buildInformationBox(context, '음주여부', _buildDrinkingInfo(context)),
          ],
        ),
      ),
    );
  }

  // 인적사항 요소
  Widget _buildInformationBox(
      BuildContext context, String title, Widget widgetDetail) {
    double cntWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: (cntWidth - 32) / 4,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black54,
                  ),
            ),
          ),
          SizedBox(
            width: ((cntWidth - 32) * 3 / 4) - 10,
            child: widgetDetail,
          ),
        ],
      ),
    );
  }

  // 생년월일
  Widget _buildBirthInfo(userInfo) {
    return GestureDetector(
      onTap: () {
        _selectDate(userInfo);
      },
      child: Row(
        children: [
          Text(
            '${userInfo.userBirth.toLocal()}'.split(' ')[0],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Icon(
            Icons.calendar_today,
            color: Colors.lightBlueAccent,
            size: 20,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(userInfo) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: userInfo.userBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != userInfo.userBirth) {
      setState(() {
        userInfo.userBirth = picked;
      });
    }
  }

  // 신장
  Widget _buildHeightInfo() {
    return TextField(
      controller: heightController,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: '신장을 입력하세요',
        errorText: errorMessage,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^(?:[1-9]?\d|[12]\d{2}|300)$')),
      ],
      onChanged: (value) {
        _validateHeight(value);
      },
    );
  }

  void _validateHeight(String value) {
    final regex = RegExp(r'^(?:[1-9]?\d|[12]\d{2}|300)$');
    setState(() {
      if (!regex.hasMatch(value)) {
        errorMessage = '신장 정보를 300cm이하인 XXXcm 형태로 입력해 주세요.';
      } else {
        errorMessage = null;
      }
    });
  }

  // 1차 직종
  Widget _build1stJobInfo(userInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FirstJobSelectPage(
              onJobSelected: (selectedJob) {
                setState(() {
                  userInfo.user1stJob = selectedJob;
                });
              },
            ),
          ),
        );
      },
      child: Text(
        userInfo.user1stJob ?? '1차 직종을 선택하세요',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  // 2차 직종
  Widget _build2ndJobInfo(userInfo) {
    return GestureDetector(
      onTap: () {
        if (userInfo.user1stJob != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondJobSelectPage(
                firstJob: userInfo.user1stJob!,
                onSubJobSelected: (selectedSubJob) {
                  setState(() {
                    userInfo.user2ndJob = selectedSubJob;
                  });
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('먼저 1차 직종을 선택하세요.')),
          );
        }
      },
      child: Text(
        userInfo.user2ndJob ?? '2차 직종을 선택하세요',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  // 거주지
  Widget _buildAddressInfo(context) {
    return Container(
      child: Text(
        '주소',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  // 종교
  Widget _buildReligionInfo(context) {
    return Container(
      child: Text(
        '종교',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  // 흡연여부
  Widget _buildSmokingInfo(context) {
    return Container(
      child: Text(
        '흡연여부',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  // 음주여부
  Widget _buildDrinkingInfo(context) {
    return Container(
      child: Text(
        '음주여부',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
