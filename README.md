# microprocessors lab programs

this repo contains the assembly source files for various lab sessions conducted as part of the microprocessors course at coep. most of the programs were expected to be performed using the [emu8086](https://emu8086-microprocessor-emulator.en.download.it/) emulator. programs involving the 8255 PPI, 8259A PIC, and 8237 DMAC were performed on the dyna86 kit.

## running the programs

to run these programs using emu8086, you'll need a windows machine.

if you're on macos or linux, you can assemble these programs using [UASM](https://github.com/Terraspace/UASM), a free MASM-compatible assembler, and run them using [dosbox-x](https://dosbox-x.com/). the macos binary comes from the [UASM macos build](https://github.com/upiter/uasmac). you can also use an [online dos emulator](https://dosasm.com/) in a pinch, provided your uni has good wifi :p

### setting up the tools

install dosbox-x using homebrew on macos, or your distribution's package manager on linux. the repository includes uasm binaries for macos and linux in the `tools/` directory.

```sh
brew install dosbox-x

git clone https://github.com/mihir262/8086-assembly-programs.git
cd 8086-assembly-programs
```

on macos, make the included assembler executable before using it:

```sh
chmod +x tools/uasm-macos
```

linux users should use `tools/uasm-linux` instead. the macos binary is built for Intel Macs and also works on Apple Silicon through Rosetta. the source files use MASM-style syntax, which is supported by uasm.

### assembling and running a program

from the repository root, assemble a program with the binary for your operating system:

```sh
# macos
tools/uasm-macos -mz programs/assignment-2/one.asm

# linux
tools/uasm-linux -mz programs/assignment-2/one.asm
```

this generates `one.exe` next to the source file. replace the path and filename with the program you want to run.

start dosbox-x and mount the repository directory:

```dos
mount c /path/to/8086-assembly-programs
c:
cd programs\assignment-2
one.exe
```

on macos, use the host path format shown above when running the `mount` command. dosbox-x translates it to a DOS drive inside the emulator.

**tip:** dosbox has limitations on file path and filename lengths, so keep filenames short. using `tab` for command autocomplete can also help.

### known issues

> **macos input issue:** entering `A` as input in dosbox-x does not seem to work on my mac, and i haven't found a fix yet. any fixes are welcome!

hope this helps juniors who learn this subject! dont let some old windows-only software ruin your lab sessions!
