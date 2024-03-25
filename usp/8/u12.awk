#!/usr/bin/awk -f

{ letters += length }
{ words += NF }
END{print letters; print words ;print NR;}

