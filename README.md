# Exapunks CPU

Watch the `Test.exaCode` run:

[![Youtube Video](https://img.youtube.com/vi/jKhGvRFbbPs/0.jpg)](https://www.youtube.com/watch?v=jKhGvRFbbPs)
--
`ExaCompiler.lua` is the poorly written compiler that turns `.exaCode` into text that can be copied into a solution

`exapunks_solution_write.lua` is used to (manually) modify a solution file since you can't copy code into Exapunks

`CPU.exa` is the code that makes up the majority of the solution (does not contain the second EXA). I use it as where I copy the compiled code into and then the code I 'upload' to a solution file. This allows code I compile to be 'running' on the most up to date 'cpu'

How To Use (Linux)
---
Have a symlink to the folder containing all of the solutions at `./solutions/`
1. Compile `Test.exaCode` with `lua -l "ExaCompiler" -e "print(Compiler:from_file('Test.exaCode'))" > ./output.txt`
2. Copy `output.txt` into `CPU.exa` between `;INSTRUCTIONS` and `;MEMORY START`
3. Upload `CPU.exa` into `./solutions/sandbox-${N}.solution` with `lua -l "exapunks_solution_write" -e "solution = ExapunksSolution:from_file('./solutions/sandbox-<N>.solution'); solution:import_code(1, 'CPU.exa'); solution:save_to_file('./solutions/sandbox-<N>.solution')"`

Structure
---
(Stolen from video description without a proofread)

* Each instruction, when compiled, is exactly 3 numbers long. I did this because trying to increment the instruction pointer a variable number made things needlessly complex when I could go with fixed width instructions. Maybe I'll change it later for more efficient programs, but I don't (currently) intend on writing anything large enough for it to be a problem.

* I planned to use a virtual stack for cpu operations, but didn't end up using it, so I instead used it for function return pointers. I understand that an actual stack holds both somehow, but this was more for fun than trying to accurately implement something.

* Because math operations are all very similar, I have each 'instruction' setup which type of operation it is. That then goes into common functions that loads the operators, and finally goes to what is essentially an if/else chain into each math operation.
These operations are a+b, a-b, b-a, a*b, a/b, b/a, etc..

  * This is the one operation (so far) that needed a 3rd register, so I made another exa whose whole purpose was to repeat back what was last said to it. In order to write to it, I have to `void m` then `copy x m`. So it's functionally a slow register that you have to tell you are writing to it.

* The way it chooses where to jump to, using the instruction number, is currently to take the 10's place, and `FJMP` `SUBI T 1 T` `FJMP` over and over for each place. Where it jumps will then do it for the 1's place, this time jumping to the instruction instead of another 'switch.' This pattern means that instruction 99 will take the longest to start, but 100 will be quite quick. I tried seeing if I could do a binary search, but that would require far too many lines as each new branch would require its own hard-coded function. I am still open to better methods though.

TODO
---
- [ ] Redo Compiler?
- [ ] Automate Compilation and Upload
- [ ] Generate a `.solution` instead of modifying one
- [ ] Rewrite How to use