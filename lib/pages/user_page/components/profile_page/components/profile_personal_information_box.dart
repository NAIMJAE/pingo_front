import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePersonalInformationBox extends StatefulWidget {
  const ProfilePersonalInformationBox({super.key});

  @override
  _ProfilePersonalInformationBoxState createState() =>
      _ProfilePersonalInformationBoxState();
}

class _ProfilePersonalInformationBoxState
    extends State<ProfilePersonalInformationBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Text(
              '인적사항',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                _personalInfoElement('생년월일', _brithInfo()),
                _personalInfoElement('신장', _heightInfo()),
              ],
            ),
            Row(
              children: [
                _personalInfoElement('거주지', _addressInfo()),
                _personalInfoElement('직종', _jobInfo()),
              ],
            ),
            Row(
              children: [
                _personalInfoElement('종교', _religionInfo()),
                _personalInfoElement('흡연여부', _smokingInfo()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalInfoElement(String title, Widget detail) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      width: MediaQuery.of(context).size.width / 2 - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 4),
          detail
        ],
      ),
    );
  }

  Widget _brithInfo() {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: Row(
        children: [
          Text(
            '${_selectedDate.toLocal()}'.split(' ')[0], // 날짜 포맷
            style: Theme.of(context).textTheme.titleLarge,
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

  // birthInfo 관련
  DateTime _selectedDate = DateTime(1998, 5, 28); // 초기값 설정
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // 날짜 선택 시 상태 업데이트
      });
    }
  }

  Widget _heightInfo() {
    return TextField(
      controller: _heightController, // 신장 입력 컨트롤러
      style: Theme.of(context).textTheme.titleLarge, // 스타일 적용
      decoration: InputDecoration(
        border: OutlineInputBorder(), // 테두리 스타일
        hintText: '신장을 입력하세요', // 힌트 텍스트
        errorText: _errorMessage, // 오류 메시지 표시
        contentPadding: EdgeInsets.zero, // 내부 여백 조정
        isDense: true,
      ),
      keyboardType:
          TextInputType.numberWithOptions(decimal: true), // 숫자와 소수점 키패드
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^\d*\.?\d{0,1}')), // 숫자와 소수점 허용
      ],
      onChanged: (value) {
        // 입력이 변경될 때마다 검증
        _validateHeight(value);
      },
    );
  }

  // _heightInfo 관련ㅇ
  TextEditingController _heightController =
      TextEditingController(); // 신장 입력 컨트롤러
  String? _errorMessage; // 오류 메시지 저장
  void _validateHeight(String value) {
    // 입력이 완료된 후에만 검증
    final regex = RegExp(r'^\d{3}\.\d{1}$');
    if (!regex.hasMatch(value)) {
      setState(() {
        _errorMessage = '신장 정보를 XXX.X 형태로 입력해 주세요.';
      });
    } else {
      setState(() {
        _errorMessage = null; // 오류 메시지 초기화
      });
    }
  }

  Widget _addressInfo() {
    return Container(
      child: Text(
        '주소',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _jobInfo() {
    return Container(
      child: Text(
        '직종',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _religionInfo() {
    return Container(
      child: Text(
        '종교',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _smokingInfo() {
    return Container(
      child: Text(
        '흡연여부',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
