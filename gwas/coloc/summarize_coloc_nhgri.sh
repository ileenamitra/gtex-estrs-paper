#!/bin/bash

# Get file with:
# p(H0) through p(H4) from coloc
# causality score of the STR

trait=$1
GWASHITS=/storage/mgymrek/gtex-estrs/revision/coloc/candidates/${trait}_nhgri_SuppDataset.tsv
OUTDIR=/storage/mgymrek/gtex-estrs/revision/coloc/nhgri/res
CANDFILE=/storage/mgymrek/gtex-estrs/revision/coloc/candidates/${trait}_nhgri_candidates.tab

echo "chrom,gene,rsid,best.tag,str.start,tissue,score,ld,p0,p1,p2,p3,p4" | sed 's/,/\t/g'

for resfile in $(ls ${OUTDIR}/${trait}_*_results.txt)
do
    gene=$(basename $resfile | awk -F"_" '{print $(NF-1)}')
    line=$(cat $resfile | head -n 2 | tail -n 1)
    p0=$(echo $line | awk '{print $1}')
    p1=$(echo $line | awk '{print $2}')
    p2=$(echo $line | awk '{print $3}')
    p3=$(echo $line | awk '{print $4}')
    p4=$(echo $line | awk '{print $5}')

    # Get tissue and SNP
    tissue=$(cat $CANDFILE | grep -w $gene | cut -f 2 | head -n 1)
    rsid=$(cat $CANDFILE | grep -w $gene | cut -f 4 | head -n 1 | sed 's/,/;/g')

    # Get LD and STR
    gwasline=$(cat $GWASHITS | grep -w $gene | sort -k8,8g | tail -n 1) # take strongest LD
    str=$(echo $gwasline | cut -f 2 -d' ')
    ld=$(echo $gwasline | cut -f 8 -d' ')
    tag=$(echo $gwasline | cut -f 10 -d' ')
    chrom=$(echo $gwasline | cut -f 1 -d' ')
    score=$(echo $gwasline | cut -f 6 -d' ')
    echo $chrom,$gene,$rsid,$tag,$str,$tissue,$score,$ld,$p0,$p1,$p2,$p3,$p4 | sed 's/,/\t/g'
done
