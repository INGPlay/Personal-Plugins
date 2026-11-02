# Shell 환경 (Windows 11 / Git Bash)

셸은 Git Bash를 우선 쓰고, PowerShell은 Git Bash로 할 수 없는 작업에만 쓴다.

- 경로는 Git Bash 형식으로 쓴다: `/c/Users/...` (`C:\Users\...` 형식은 쓰지 않는다)
- 새로 만드는 파일의 줄바꿈은 LF로 한다.
- Bash 명령에는 `PYTHONUTF8=1`이 설정되어 있어 Python의 한글 입출력이 UTF-8로 처리된다. Bash 밖(PowerShell 등)에서 Python을 실행해 한글이 깨지면 이 변수를 직접 지정한다.
