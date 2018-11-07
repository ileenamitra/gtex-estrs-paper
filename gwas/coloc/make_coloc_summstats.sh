#!/bin/bash

source params.sh
# Make coloc files from all the summary stats files
# Files have chrom,start,end,beta,sebeta,p,maf

# IBD
IBD=/storage/mgymrek/gtex/gwas/summarystats/EUR.IBD.gwas_info03_filtered.assoc 
cat ${IBD} | grep -v Direction | \
    awk '{print $1 "\t" $3 "\t" $3+1 "\t" log($9) "\t" $10/$9 "\t" $11 "\t" "NA"}' | \
    sort -k1,1 -k2,2n | \
    bgzip -c > ${OUTDIR}/ibd_coloc.bed.gz
tabix -p bed ${OUTDIR}/ibd_coloc.bed.gz
exit 1

# HDL
HDL=/storage/mgymrek/gtex/gwas/summarystats/HDL_Meta_ENGAGE_1000G.txt.gz
zcat ${HDL} | grep -v pos | \
    awk '{print $1 "\t" $2 "\t" $2+1 "\t" $5 "\t" $6 "\t" $7 "\t" "NA"}' | \
    sort -k1,1 -k2,2n | \
    bgzip -c > ${OUTDIR}/hdl_coloc.bed.gz
tabix -p bed ${OUTDIR}/hdl_coloc.bed.gz
exit 1

# Height
HT=/storage/mgymrek/gtex/gwas/summarystats//Meta-analysis_Wood_et_al+UKBiobank_2018.txt.gz
zcat ${HT} | grep -v Tested | \
    awk '{print $1 "\t" $2 "\t" $2+1 "\t" $7 "\t" $8 "\t" $9 "\t" $6}' | \
    sort -k1,1 -k2,2n | \
    bgzip -c > ${OUTDIR}/height_coloc.bed.gz
tabix -p bed ${OUTDIR}/height_coloc.bed.gz

# SCZ
SCZ_PGC=/storage/mgymrek/gtex/gwas/summarystats/ckqny.scz2snpres.gz
zcat ${SCZ_PGC} | grep -v hg19chrc | \
    awk '{print $1 "\t" $5 "\t" $5+1 "\t" log($7) "\t" $8/$7 "\t" $9 "\t" "NA"}' | \
    sed 's/chr//' | \
    bgzip -c > ${OUTDIR}/scz_pgc_coloc.bed.gz
tabix -p bed ${OUTDIR}/scz_pgc_coloc.bed.gz


# Blood traits
HGB_ASTLE=/storage/mgymrek/gtex/gwas/summarystats/hgb_N172925_wide_form.tsv.gz
BASOP_ASTLE=/storage/mgymrek/gtex/gwas/summarystats/baso_p_gran_N170223_wide_form.tsv.gz
RBC_ASTLE=/storage/mgymrek/gtex/gwas/summarystats/rbc_N172952_wide_form.tsv.gz

for btf in ${BASOP_ASTLE} ${RBC_ASTLE} ${HGB_ASTLE}
do
    prefix=$(basename ${btf} | sed 's/_wide_form.tsv.gz//')
    echo $prefix
    zcat ${btf} | awk '{print $4 "\t" $5 "\t" $5+1 "\t" $11 "\t" $12 "\t" $13 "\t" $16}' | grep -v  EFFECT |\
	bgzip -c > ${OUTDIR}/${prefix}_coloc.bed.gz
    tabix -p bed ${OUTDIR}/${prefix}_coloc.bed.gz
done
