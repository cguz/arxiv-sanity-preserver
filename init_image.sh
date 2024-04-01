#!/bin/bash

#create user based on owner and group of data directory
SUID=$(stat -c %u data)
SGID=$(stat -c %g data)
if [ ! "$SUID" == "0" ]; then
  groupadd -g $SGID sanity
  useradd -u $SUID -g $SGID sanity
  SUSER=sanity
else
  SUSER=root
fi

python /usr/src/app/fetch_papers.py --max-index=10 --results-per-iteration=20
python /usr/src/app/download_pdfs.py
python /usr/src/app/parse_pdf_to_text.py
python /usr/src/app/thumb_pdf.py
python /usr/src/app/analyze.py
python /usr/src/app/buildsvm.py
python /usr/src/app/make_cache.py
