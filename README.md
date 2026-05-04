# LC-2K-LC-2K-Simulator
Simulator for LC-2K assembly (the ISA taught in EECS 370 @ UMich) written in LC-2K assembly. 

I decided to make this simulator during finals week as I thought it would be a fun project that would be much more enjoyable than studying. LC-2K is the basic assembly language taught in EECS 370 (Intro to Computer Organization). This simulator is written entirely in LC-2K, and takes in another LC-2K program and simulates it.

# Usage
This simulator can be run in two ways. If you have an LC-2K assembler, linker and simmulator you can download this assembly file and use it as the primary file in the linking process. For this to work, you will need to remove the last line (containing the label SMEM), and modify the other file you'd like to run to have the label SMEM in the first line (or add a NOOP to the front with that label if the existing first line has a different label already). You'll also want to modify your simulator written in C to print out the DATA section of the file (the first 8 .fill lines contain the values of simulated registers. 

Alternatively (and much more easily), you can use the online LC-2K simulator made by the course staff: https://eecs370.github.io/simulators/lc2k/
This simulator doesn't allow you to link files though, so you'll need to transform the LC-2K file you'd like to run with the Python script provided. This script will take your machine code file and transform it into .fill lines, with the first line having the label SMEM, which can be pasted into the last line of simulator file. This does however still require you to have an assembler to turn your assembly file into machine code, which I can't provide.

# Performance
I ran the P1 Spec and my solution to P2r (Winter 26) normally and through my simulator to attain the following:

|         | Instrs Exed Normal | Instrs Exed Sim    | Sim / Normal |
| ------: | :----------------: | :----------------: | :----------: |
| P1 Spec | 17                 | 1078               | 63.4         |
| P2r     | 1218               | 90780              | 74.5

I estimate it takes around 6 to 7 (*10) instructions to simulate one LC-2K instruction. It can problably be optimized, but I'm not going to.

# Another version, and ED Post Edit

https://git.sr.ht/~fkfd/p1s-lc2k

Edit: After seeing the version by Yihang Yin (linked in replies, check it out!), I thought I'd elaborate a little bit on part of my code. Massive props to them for implementing bitshifting (which I thought would be way too dificult lol). When I determine the Opcode of an instr at the start of sLOOP, and when I find which RegA and RegB in my functions sddRA and sddRB, I avoid using bitshifting through the following:
1: AND (using (A NOR A) NOR (B NOR B)) the instr with a mask that makes all other bits not in that specifc field 0 (0b111 << 22 for opcode). 

2: BEQ that resulting value with all possible matches (luckily only 8, since they are only 3 bits), where the matches are 0 through 7 left shifted however many times is needed for that field (22, 19, 16).

3: Those BEQs lead to either the correct opcode being called, or to the correct branch that will store the nonshifted value (if matches 7 << 19, store 7) in either RA or RB. 

I think this primarily is what led to my version's performance gains, although it definitely is less cool haha. It takes about 1078 instrs to execute the p1 spec, which normally takes 17 instrs, meaning it took about 63.4 instrs to execute each instr. I estimate off this it takes anywhere between 60 to 70 instructions to execute one instr.

# LC-2K
I'm not sure if I'm allowed to upload a spec of LC-2K, so I'm not going to. But it can fairly easily found by looking up LC-2K. It's basically an ISA with only 8 instructions.
