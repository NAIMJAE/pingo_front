import 'package:daum_postcode_search/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/user_model/user_info.dart';
import 'package:pingo_front/ui/widgets/post_code_search.dart';
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
  final TextEditingController _heightController = TextEditingController();
  String? errorMessage;

  // 주소
  final TextEditingController _userAddressController = TextEditingController();

  // 흡연여부

  // 음주여부

  // 혈액형

  @override
  Widget build(BuildContext context) {
    final userInfo = widget.copyUserInfo;

    logger.i(userInfo);
    // 유저 정보가 있을 경우 해당 값을 사용, 없으면 기본값 설정
    // 신장
    _heightController.text = userInfo.userHeight?.toString() ?? '';

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
            _buildInformationBox(context, '신장', _buildHeightInfo(userInfo)),
            _buildInformationBox(context, '1차 직종', _build1stJobInfo(userInfo)),
            _buildInformationBox(context, '2차 직종', _build2ndJobInfo(userInfo)),
            _buildInformationBox(context, '거주지',
                _buildAddressInfo(userInfo, false, _userAddressController)),
            _buildInformationBox(
              context,
              '종교',
              Wrap(
                spacing: 4.0,
                children: [
                  _buildSelectedButton(
                    widget.copyUserInfo.userReligion,
                    "무교",
                  ),
                  _buildSelectedButton(
                    widget.copyUserInfo.userReligion,
                    "천주교",
                  ),
                  _buildSelectedButton(
                    widget.copyUserInfo.userReligion,
                    "불교",
                  ),
                  _buildSelectedButton(
                    widget.copyUserInfo.userReligion,
                    "기독교",
                  ),
                  _buildSelectedButton(
                    widget.copyUserInfo.userReligion,
                    "기타",
                  ),
                ],
              ),
            ),
            _buildInformationBox(
              context,
              '흡연여부',
              Wrap(
                spacing: 4.0,
                children: [
                  _buildSelectedButton(
                    _buildUserSmokingParse(widget.copyUserInfo.userSmoking),
                    "비흡연",
                  ),
                  _buildSelectedButton(
                    _buildUserSmokingParse(widget.copyUserInfo.userSmoking),
                    "흡연",
                  ),
                ],
              ),
            ),
            _buildInformationBox(
              context,
              '음주여부',
              Wrap(
                spacing: 4.0,
                children: [
                  _buildSelectedButton(
                    _buildUserDrinkingParse(widget.copyUserInfo.userDrinking),
                    "비음주",
                  ),
                  _buildSelectedButton(
                    _buildUserDrinkingParse(widget.copyUserInfo.userDrinking),
                    "가끔 음주",
                  ),
                  _buildSelectedButton(
                    _buildUserDrinkingParse(widget.copyUserInfo.userDrinking),
                    "잦은 음주",
                  ),
                ],
              ),
            ),
            _buildInformationBox(
              context,
              '혈액형',
              Wrap(
                spacing: 4.0,
                children: [
                  _buildSelectedButton(
                    _buildUserBloodTypeParse(widget.copyUserInfo.userBloodType),
                    "A형",
                  ),
                  _buildSelectedButton(
                    _buildUserBloodTypeParse(widget.copyUserInfo.userBloodType),
                    "B형",
                  ),
                  _buildSelectedButton(
                    _buildUserBloodTypeParse(widget.copyUserInfo.userBloodType),
                    "O형",
                  ),
                  _buildSelectedButton(
                    _buildUserBloodTypeParse(widget.copyUserInfo.userBloodType),
                    "AB형",
                  ),
                ],
              ),
            ),
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
  Widget _buildHeightInfo(userInfo) {
    _heightController.text = userInfo.userHeight?.toString() ?? '';

    return TextField(
      controller: _heightController,
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
  Widget _buildAddressInfo(
      userInfo, obscure, TextEditingController _userAddressController) {
    _userAddressController.text = userInfo.userAddress ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onTap: () async {
            final selectedAddress = await Navigator.push<DataModel>(
              context,
              MaterialPageRoute(
                builder: (context) => PostCodeSearchScreen(
                  onSelected: (address) {
                    Navigator.pop(context, address); // 선택된 주소 반환
                  },
                ),
              ),
            );

            if (selectedAddress != null) {
              _userAddressController.text = selectedAddress.roadAddress;
            }
            setState(() {});
          },
          readOnly: true,
          controller: _userAddressController,
          style: Theme.of(context).textTheme.headlineSmall,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '주소를 입력하세요',
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          obscureText: obscure,
        ),
      ],
    );
  }

// 버튼 위젯(종교, 흡연여부, 음주여부)
  Widget _buildSelectedButton(userValue, btnText) {
    return TextButton(
      onPressed: () {
        // 누르면 선택되어 있는 값이 누른 값으로 변경
        setState(() {});
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          userValue == btnText ? Colors.lightBlueAccent : Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all(
          userValue == btnText ? Colors.white : Colors.lightBlueAccent,
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: Colors.lightBlueAccent),
        ),
      ),
      child: Text(btnText),
    );
  }

  // 음주여부
  String _buildUserDrinkingParse(drinking) {
    switch (drinking) {
      case 'N':
        return '비음주';
      case 'O':
        return '가끔 음주';
      case 'F':
        return '잦은 음주';
      default:
        return '';
    }
  }

  String _buildUserSmokingParse(smoking) {
    switch (smoking) {
      case 'F':
        return '비흡연';
      case 'T':
        return '흡연';
      default:
        return '';
    }
  }

  String _buildUserBloodTypeParse(bloodType) {
    switch (bloodType) {
      case 'A':
        return 'A형';
      case 'B':
        return 'B형';
      case 'O':
        return 'O형';
      case 'AB':
        return 'AB형';
      default:
        return '';
    }
  }
}
