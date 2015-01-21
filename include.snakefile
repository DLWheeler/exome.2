rule allexomeseqpairs:
    input:  expand("{s}"+ext,s=samples),
            expand("{s}.flags",s=samples),
            expand("{s}.dedup.flags",s=samples),
            expand("{s}.coverage.done",s=samples),
            expand("{s}.snp",s=pairs),
            expand("{s}.snp.vcf.av",s=pairs),
            expand("{s}.uniqcov",s=samples)
    output: 
    params: s=expand("{s}",s=samples)
    shell: "mv *metrics* QC mv *.pdf QC mv *uniq* QC mv *tbl* QC mv *.flags QC;mv *.png QC;mv *.txt QC;cd QC; Rscript align_qc.R {params.s}"

include: "Rules/annovar.rl"
include: "Rules/checkqc.rl"
include: "Rules/coverage_qc.rl"
include: "Rules/flagstats.rl"
include: "Rules/flagstats_dedup.rl"
include: "Rules/headers.rl"
include: "Rules/index_ref.rl"
include: "Rules/map_pe.rl"
include: "Rules/markdups.rl"
include: "Rules/mpileup.rl"
include: "Rules/realign.rl"
include: "Rules/recal.rl"
include: "Rules/sam2bam.rl"
include: "Rules/sort.rl"
include: "Rules/varscan.rl"
