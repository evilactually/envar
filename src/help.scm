(define usage-msg #<<EOF
Syntax:

# This is a comment
VARIABLE : [THIS IS VALUE] # sets **user** environment variable 
                           # %VARIABLE% to "THIS IS VALUE"

VARIABLE : [THIS]          # exactly the same, just split up in two parts
           [IS VALUE] 
                           
@VARIABLE : [VALUE]        # here VARIABLE is a **system** environment variable
                           # as opposed to **user**

VARIABLE +                 # creates a new user variable, without setting it's value
VARIABLE -                 # removes a user variable
                           # (space before + and - is optional)

@VARIABLE -                # same but for a system variable

@PATH : [$(%PATH%)]        # $(...) means evaluate whatever is inside parenthesis
        [C:\ruby\bin]      # in a system shell. %PATH% evaluates to a value of the 
                           # PATH variable

Statements can be written next to each other or on separate lines:

    @VARIABLE: [VALUE] VARIABLE+ @PATH: [$(%PATH%)] [C:\ruby\bin]   
  
Usage:

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
        envar JAVA_HOME : [C:\Java\bin] RUBY_HOME- # set JAVA_HOME 
                                                   # and remove RUBY_HOME

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
 
