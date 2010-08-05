#!/bin/bash
MAIN_FILE=$1
CROP_PDF_FILE=$MAIN_FILE-crop.pdf
echo "Running LaTeX to approximate height"
cat $1.tex | sed 's/\\begin{document}/\\pagestyle{empty}\\begin{document}/ ; s/\\newpage/\\bigskip/g' | latex --jobname=$1 >/dev/null 
PAGES=$(grep -o "[0-9]\+ pages\?, " $1.log | grep -o "[0-9]*")
echo "We have $PAGES page(s)"
H=$(( 9 * PAGES))
PH=$(( H + 1))
echo "Re-running latex with approximative height $PH inches" 
cat $1.tex | sed "s/\\\\begin{document}/\\\\geometry{papersize={1200mm,${PH}in},textheight=${H}in,textwidth=1180mm}\\\\pagestyle{empty}\\\\begin{document}\\\\noindent\\\\hspace{-2px}\\\\rule{1px}{1px}/ ; s/\\\\end{document}/\\\\par\\\\noindent\\\\hspace{-2px}\\\\rule{1px}{1px}\\\\end{document}/ ; s/\\\\newpage/\\\\par\\\\noindent\\\\hspace{-2px}\\\\rule{1px}{1px}\\\\newpage\\\\noindent\\\\hspace{-2px}\\\\rule{1px}{1px}/g" |latex --jobname=$1 |grep wide
echo "Converting to postscript"
dvips $MAIN_FILE -i -o $MAIN_FILE-ps- 2>/dev/null
echo "Converting to eps"
find . -name "$MAIN_FILE-ps-[0-9][0-9][0-9]" -exec ps2eps -f -q -P -H -l {} \;
echo "Converting to pdf"
gs -q -dNOPAUSE -dEPSCrop -dBATCH -sDEVICE=pdfwrite -sOutputFile=$CROP_PDF_FILE `ls $MAIN_FILE-ps-[0-9][0-9][0-9].eps`
