#!/usr/bin/env bash
languages="arduino assembly awk bash basic bf c chapel clean clojure coffee cpp csharp d dart delphi dylan eiffel elixir elisp elm erlang factor fortran forth fsharp go groovy haskell java js julia kotlin latex lisp lua matlab nim ocaml octave perl perl6 php pike python python3 r racket ruby rust scala scheme solidity swift tcsh tcl objective-c vb vbnet"

online_topic_list=`curl -s cht.sh/:list`
topic_list="$online_topic_list my"
topic=`echo $topic_list | tr ' ' '\n' | fzf`
if [[ -z $topic ]]; then
    exit 0
fi

if echo $languages | grep -qs $topic; then
  #echo 'Language'
  read -p "Topic: $topic. Enter Query: " query
  curl -s cht.sh/$topic/`echo $query | tr ' ' '+'` | batcat -p
elif [ $topic = "my" ]; then
  local_cheat_sheet=`ls $HOME/.config/cheatsheet | fzf`
  batcat -p $HOME/.config/cheatsheet/$local_cheat_sheet
else
  #echo 'Tool'
  read -p "Topic: $topic. Enter Query: " query
  curl -s cht.sh/$topic~$query | batcat -p
fi
