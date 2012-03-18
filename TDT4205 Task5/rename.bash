#!/bin/bash
for f in *.gv.pdf; do mv -f "$f" "${f%.gv.pdf}.pdf"; done
