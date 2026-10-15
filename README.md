# microprocessors lab programs

this repo contains the assembly source files for various lab sessions conducted as part of the microprocessors course at coep. most of the programs were expected to be performed using the [emu8086](https://emu8086-microprocessor-emulator.en.download.it/) emulator. programs involving the 8255 PPI, 8259A PIC, and 8237 DMAC were performed on the dyna86 kit.

## running the programs

to run these programs using emu8086, you'll need a windows machine.

if you're on macos or linux, you can assemble and run the source files using [dosbox-x](https://dosbox-x.com/) or an [online dos emulator](https://dosasm.com/). the online emulator is great in a pinch, provided your uni has good wifi :p

### setting up dosbox-x on macos

install dosbox-x using homebrew and create a directory in your home folder to store the assembly programs and tools.

```sh
brew install dosbox-x

mkdir -p ~/8086/programs
mkdir -p ~/8086/tools
```

you'll need to place the assembler, linker, and related executables in the `tools/` directory. i cannot mention where i got these executables as they are proprietary software and i cannot legally distribute or bundle these with my code.

you can now write and edit your assembly programs in `~/8086/programs` using your favourite text editor.

### assembling and running a program

start dosbox-x and execute the following commands:

```dos
mount c ~/8086
c:
cd programs
\tools\masm.exe filename.asm
\tools\link.exe filename.obj
filename.exe
```

replace `filename` with the name of your assembly source file.

the assembler generates an object file (`.obj`), which the linker then converts into an executable (`.exe`). you can run the executable directly from the `programs` directory.

**tip:** dosbox has limitations on file path and filename lengths, so keep filenames short. using `tab` for command autocomplete can also help.

### known issues

> **macos input issue:** entering `A` as input in dosbox-x does not seem to work on my mac, and i haven't found a fix yet. any fixes are welcome!

hope this helps juniors who learn this subject! dont let some old windows-only software ruin your lab sessions!
