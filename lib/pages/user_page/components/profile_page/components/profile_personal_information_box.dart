import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePersonalInformationBox extends StatelessWidget {
  ProfilePersonalInformationBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildPersonalInfoElement(
                  context,
                  '생년월일',
                  _buildBirthInfo(context),
                ),
                _buildPersonalInfoElement(
                  context,
                  '신장',
                  _buildHeightInfo(context),
                ),
              ],
            ),
            Row(
              children: [
                _buildPersonalInfoElement(
                  context,
                  '거주지',
                  _buildAddressInfo(context),
                ),
                _buildPersonalInfoElement(
                  context,
                  '직종',
                  _buildJobInfo(context),
                ),
              ],
            ),
            Row(
              children: [
                _buildPersonalInfoElement(
                  context,
                  '종교',
                  _buildReligionInfo(context),
                ),
                _buildPersonalInfoElement(
                  context,
                  '흡연여부',
                  _buildSmokingInfo(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 인적사항 요소
  Widget _buildPersonalInfoElement(context, title, detail) {
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
          detail,
        ],
      ),
    );
  }

  // 생년월일
  final ValueNotifier<DateTime> selectedDateNotifier =
      ValueNotifier(DateTime(1998, 5, 28));
  Widget _buildBirthInfo(context) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: ValueListenableBuilder<DateTime>(
        valueListenable: selectedDateNotifier,
        builder: (context, selectedDate, child) {
          return Row(
            children: [
              Text(
                '${selectedDate.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Icon(
                Icons.calendar_today,
                color: Colors.lightBlueAccent,
                size: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateNotifier.value,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDateNotifier.value) {
      selectedDateNotifier.value = picked; // 날짜 선택 시 상태 업데이트
    }
  }

  // 신장
  final TextEditingController heightController = TextEditingController();
  final ValueNotifier<String?> errorMessageNotifier = ValueNotifier(null);
  Widget _buildHeightInfo(context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorMessageNotifier,
      builder: (context, errorMessage, child) {
        return TextField(
          controller: heightController,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '신장을 입력하세요',
            errorText: errorMessage,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
          ],
          onChanged: (value) {
            _validateHeight(value);
          },
        );
      },
    );
  }

  void _validateHeight(String value) {
    final regex = RegExp(r'^\d{3}\.\d{1}$');
    if (!regex.hasMatch(value)) {
      errorMessageNotifier.value = '신장 정보를 XXX.X 형태로 입력해 주세요.';
    } else {
      errorMessageNotifier.value = null; // 오류 메시지 초기화
    }
  }

  // 거주지
  Widget _buildAddressInfo(context) {
    return Container(
      child: Text(
        '주소',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  // 직종
  Widget _buildJobInfo(context) {
    return Container(
      child: Text(
        '직업',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  // 종교
  Widget _buildReligionInfo(context) {
    return Container(
      child: Text(
        '종교',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  // 흡연여부
  Widget _buildSmokingInfo(context) {
    return Container(
      child: Text(
        '흡연여부',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
