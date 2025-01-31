// 안드로이드 스튜디오의 에뮬레이터는 로컬환경이 아닌 가상 디바이스라서
// localhost 또는 127.0.0.1 로 로컬에서 실행한 서버에 접근할 수 없음
// 대신 10.0.2.2로 접근 가능
// 근데 usb포트로 기기를 연결해서 사용하면 접근 못하기 때문에
// 이 경우에는 내 로컬 IP주소를 입력해주어야 함
const String rootURL = 'http://10.0.2.2:8080/pingo';
