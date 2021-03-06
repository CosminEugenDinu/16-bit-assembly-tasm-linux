# 16-bit-assembly-tasm-linux
Compile and run Turbo Assembler (TASM) files on GNU/Linux - Ubuntu-20.04
## Compile and run 16 bit Turbo Assembly files
### *Prerequisites:*
- GNU/Linux - Ubuntu-20.04
- [dosemu2](https://github.com/dosemu2/dosemu2/wiki/Setup-guide-for-advanced-users-and-ambitious-beginners-(using-Ubuntu)) - dos emulator 
- [emu2](https://github.com/dmsc/emu2.git) - light weight dos emulator (I used it to run .exe files)
- TASM - Borland Turbo Assembler (is found in `TASM` directory)
This is used for run `TASM.EXE /zi /la code.asm` and `TLINK.EXE /v code.obj`.
- Install prerequisites:
```bash
# install dosemu
sudo add-apt-repository ppa:dosemu2/ppa
sudo apt update
sudo apt install dosemu2 

# install emu2
git clone https://github.com/dmsc/emu2.git
cd emu2
make
sudo cp emu2 /usr/bin
```
### *Install:*
```bash
git clone https://github.com/CosminEugenDinu/16-bit-assembly-tasm-linux.git
cd 16-bit-assembly-tasm-linux
chmod +x compile.sh
```
### *Usage:*
```bash
# in projects directory are some sample .asm files
# compile and run one of them like this:
./compile.sh projects/ex1.asm

# now you should see some files in tasm, like ex1.obj, ex1.exe, ...
# the results or running `emu2 code.exe` is printed in terminal
# SUCCESS !

```
- for debugging inspect `logfile` (this file is created first time you run ./compile.sh)

### *Description:*
- Compile `asm` file using dosemu:
#### !!! Assembly file name must have max 8 characters for base filename and 3 chars for extension !!!
```bash
# cd to your root project (let's say this includes TASM/TASM.EXE and projects/Code.asm)
# -K: directory of programs that will be run dos command, -E: dos command, -dumb: view result of dos command
# ex: the next command lists current directory as it is seen from dos
dosemu -K '.' -E 'dir' -dumb

# compile asm
dosemu -K '.' -E 'TASM\TASM.EXE /zi /la projects\Code.asm' -dumb

# now you have files: code.lst, code.obj
```
- Linking:
```bash
dosemu -K '.' -E 'TASM\TLINK.EXE /v code.obj' -dumb

# now you generated file code.exe
```
- Execute:
```bash
emu2 code.exe
```
