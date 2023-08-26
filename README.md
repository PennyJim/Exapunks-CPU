# Exapunks CPU

Watch the [Test.exaCode](./Test.exaCode) run:

[![Youtube Video](https://img.youtube.com/vi/jKhGvRFbbPs/0.jpg)](https://www.youtube.com/watch?v=jKhGvRFbbPs)

[kaitai-runtime](./kaitai-runtime/)
-
Relevant file within kaitai-runtime is `ExaCompiler.lua`. 

`exapunks_solution.lua` is used to (manually) modify a solution file since you can't copy code into Exapunks

kaitai-runtime should be a git submodule of `https://github.com/kaitai-io/kaitai_struct_lua_runtime.git`, but I barely know how to use lua (and have never used a git submodule), and requiring from outside the folder causes its own requires to fail.
