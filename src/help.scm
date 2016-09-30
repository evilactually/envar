
(define usage-msg #<<EOF

Script Syntax:

    Statement structure:
        
        [SCOPE MODIFIER]VARIABLE [OPERATOR];
  
    Comments:

        // comment string

    Operators:

        Create variable:
            "+" 

        Remove variable:
            "-" 

        Assign variable
            ": [text] [$(VAR)] [$(shell cmd)] ..." 

        Print variable:
            "" (no op) 

    Scope modifier:

        User scope:
            "" (no modifier, default)

        System scope:
            "@"

Script Examples:

    Create variable:

        VAR +;

    Remove variable:

        VAR -;

    Assign(and auto create):

        VAR : [value 1]
              [value 2];

    Assign system scope:

        @VAR : [value 1]
               [value 2];

    Reference another variable:

        @VAR_A : [value of A];
        @VAR_B : [value of B];
        @VAR_BOTH : [I have $(@VAR_A)]
                    [ and ]
                    [$(@VAR_B)];

    Print value of a variable to stdout:

        VAR;

Command Line Usage:

    envar {SCRIPT LINE | -{i|e} [SCRIPT FILE]}

    -i : import script from file if such is specified, or read it from 
         standard input

    -e : export current state of all variables into a script file or standard 
         output if no file is specified. Each found environment variable 
         produces a set statement in generated script file with it's current
         name and value.

EXECUTING SCRIPTS:

    You can pass a script directly as an argument or read it from file 
    or standard input.

Examples:

    Directly passing a script line:

        envar JAVA_HOME:[C:\Java\bin]; RUBY_HOME-;

    Reading script from a file:

        envar -i script_file

    Passing a script using pipes (notice missing file parameter):

        envar -i < script_file
    OR
        echo "JAVA_HOME : [C:\Java\bin]" | envar -i

GENERATING SCRIPTS:
    
    It may be beneficial to be able to save all current user and system environment 
    variables into a file for later loading. It can be accomplished with -e 
    option (export)

Examples:

    Exporting to file:

        envar -e saved_file 

    Exporting to standard output:

        envar -e

    Exporting to file through a pipe:

        envar -e > saved_file
EOF
)
 
