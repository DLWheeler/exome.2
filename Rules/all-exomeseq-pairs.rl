rule all_exomeseq_pairs:
    input:  expand("{s}"+ext,s=samples),
            expand("{s}.flags",s=samples),
            expand("{s}.dedup.flags",s=samples),
            expand("{s}.coverage.done",s=samples),
            expand("{s}.snp",s=pairs),
            expand("{s}.snp.vcf.av",s=pairs),
            expand("{s}.uniqcov",s=samples)
    output: 
    params: s=expand("{s}",s=samples)
    shell: "mv *metrics* QC; mv *.pdf QC; mv *uniq* QC; mv *tbl* QC; mv *.flags QC;mv *.png QC;mv *.txt QC;cd QC; Rscript align_qc.R {params.s}"
