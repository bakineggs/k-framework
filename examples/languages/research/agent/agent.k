

require /modules/exp
require /modules/if
require /modules/lambda
require /modules/mu
require /modules/callcc
require /modules/halt
require /modules/seq
require /modules/io
require /modules/ref
require /modules/while
require /modules/threads
require /modules/agents
require /modules/quote-unquote

require ../../../../tests/regression/ids
require ../../../../tests/regression/exp/programs
require ../../../../tests/regression/lambda/programs
require ../../../../tests/regression/mu/programs
require ../../../../tests/regression/callcc/programs
require ../../../../tests/regression/halt/programs
require ../../../../tests/regression/io/programs
require ../../../../tests/regression/imp/programs
require ../../../../tests/regression/threads/programs
require ../../../../tests/regression/agents/programs
require ../../../../tests/regression/quote-unquote/programs

kmod AGENT is 
  including EXP 
  including LAMBDA
  including MU
  including CALLCC
  including HALT 
  including IO 
  including REF 
  including WHILE 
  including THREADS 
  including AGENTS 
  including QUOTE-UNQUOTE 

   including EXP-PROGRAMS + LAMBDA-PROGRAMS + MU-PROGRAMS + CALLCC-PROGRAMS
   including HALT-PROGRAMS + IO-PROGRAMS + IMP-PROGRAMS 
   including THREADS-PROGRAMS + AGENTS-PROGRAMS + QUOTE-UNQUOTE-PROGRAMS
 configuration
    <T>
      <agent multiplicity="*"> 
          <control>
              <thread multiplicity="*">
                  <k>.K</k>
                  <nextId>0</nextId>
                  <holds>.Map</holds>
              </thread>
          </control>
          <busy>.Set</busy> 
          @latex("\\kBR")
          <mem> .Map </mem> <nextLoc> 0 </nextLoc>
          <me>0</me>
          <parent>-1</parent>
      </agent>
      @latex("\\kBR")
      <nextAgent>1</nextAgent>
      <world>SetItem(0)</world>
      <barrier>true</barrier> <waiting>.Set</waiting>
      @latex("\\kBR")
      <messages> <message multiplicity="*">
          <from>.K</from> <to>.Set</to> <body>.K</body>
      </message> </messages>
      <I-O> <in>.List</in> <out>.List</out> </I-O>
    </T>

  syntax KResult ::= Id

  syntax Bag ::= run ( KLabel ) | run ( KLabel , List{K} )

  macro run(KL:KLabel) = <T_> <k>KL(.List{K})</k> <_/T>
  macro run(KL:KLabel,L:List`{K`}) 
      = <T_> <k> KL(.List{K}) </k> <in>List(L)</in> <_/T>
endkm

