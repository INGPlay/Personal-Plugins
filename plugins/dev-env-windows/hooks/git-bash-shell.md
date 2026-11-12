# Shell 환경 (Windows 11 / Git Bash)

셸은 Git Bash를 우선 쓰고, PowerShell은 Git Bash로 할 수 없는 작업에만 쓴다.

- 경로는 Git Bash 형식으로 쓴다: `/c/Users/...` (`C:\Users\...` 형식은 쓰지 않는다)
- 새로 만드는 파일의 줄바꿈은 LF로 한다.
- Bash 명령에는 `PYTHONUTF8=1`이 설정되어 있어 Python의 한글 입출력이 UTF-8로 처리된다. Bash 밖(PowerShell 등)에서 Python을 실행해 한글이 깨지면 이 변수를 직접 지정한다.
- `pdftotext`는 기본 출력 인코딩이 Latin1이어서 한글이 모두 사라진다. Bash 명령에서는 `-enc UTF-8`을 붙이는 래퍼 함수가 설정되어 있고, 래퍼가 없는 환경에서는 `pdftotext -enc UTF-8 file.pdf -`처럼 직접 지정한다.
- 여러 파일을 고치는 패치나 긴 Python 코드는 Bash 명령에 직접 넣지 않고, Write로 스크립트 파일을 만든 뒤 실행한다. 스크립트는 저장소가 아니라 세션의 임시 디렉터리(scratchpad)에 만든다. Windows에서는 `bash -c` 문자열이 약 8,000자에서 잘려 대개 `unexpected EOF while looking for matching` 오류가 나지만, 잘린 위치에 따라 오류 없이 앞부분만 실행되기도 한다. 잘릴 길이의 Bash 명령은 훅이 실행 전에 차단하므로, 차단되면 같은 명령을 다시 보내지 말고 스크립트 파일로 옮긴다.
- Bash 명령 안의 `\\`는 heredoc 안에서도 `\`로 줄어든다. 정규식이나 UNC 경로처럼 `\\`가 들어가는 내용은 Edit·Write로 파일에 쓴다.
