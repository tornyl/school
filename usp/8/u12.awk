#!/usr/bin/awk -f

{ letters += length + 1 }
{ words += NF }
END{print "letters " letters; print "words "  words ;print "lines "  NR;}

