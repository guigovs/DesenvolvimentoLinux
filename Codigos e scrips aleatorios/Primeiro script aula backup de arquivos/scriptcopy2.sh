#!/bin/bash

function existe()
{
	return [ -e $1]
}

function copia()
{
	data=$(date +F)
	destino="$1.bak_$data"
	cp $1 $destino
}

if existe $1;
then
	copia $1
else
fi
