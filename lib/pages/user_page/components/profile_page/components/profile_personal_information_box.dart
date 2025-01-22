import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter

class ProfilePersonalInformationBox extends StatefulWidget {
  const ProfilePersonalInformationBox({super.key});

  @override
  _ProfilePersonalInformationBoxState createState() =>
      _ProfilePersonalInformationBoxState();
}

class _ProfilePersonalInformationBoxState
    extends State<ProfilePersonalInformationBox> {
  DateTime _selectedDate = DateTime(1998, 5, 28); // 초기값 설정
  TextEditingController _heightController =
      TextEditingController(); // 신장 입력 컨트롤러
  String? _errorMessage; // 오류 메시지 저장

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
                _personalInfoElement('주소지', _addressInfo()),
              ],
            ),
            Row(
              children: [
                _personalInfoElement('신장', _brithInfo()),
                _personalInfoElement('직업', _addressInfo()),
              ],
            ),
            Row(
              children: [
                _personalInfoElement('종교', _brithInfo()),
                _personalInfoElement('음주여부', _addressInfo()),
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
          Text(title, style: Theme.of(context).textTheme.titleLarge),
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Icon(
            Icons.calendar_today,
            color: Colors.lightBlueAccent,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget _addressInfo() {
    return Text('주소입니다.');
  }
}
