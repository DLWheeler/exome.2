pver=['test','v1','v2'][2]

configfile: "project.json"

samples=sorted(list(config['samples'].keys()))
pairs=sorted(list(config['pairs'].keys()))
groot=config['references']['GENOME'].split(".")[0]
ext=".pileup.recal.realign.fin.dedup.sorted.bam"
ext2=[ext,ext]

rule all:
    input:  expand("{s}"+ext,s=samples),
            expand("{s}.flags",s=samples),
            expand("{s}.dedup.flags",s=samples),
            expand("{s}.coverage.done",s=samples),
            expand("{s}.snp",s=pairs),
            expand("{s}.snp.vcf.av",s=pairs)
    output: 
    params: s=expand("{s}",s=samples)
    shell: "mv *.flags QC;mv *.png QC;mv *.txt QC;cd QC; Rscript align_qc.R {params.s}"

rule index_ref:
    input:  config['references']['GENOME']
    output: config['references']['GENOME']+".bwt"
    params: bwa=config['bin']['BWA'],ref=config['references']['GENOME']
    shell:  config['rules']['index_ref'][pver]

rule map_pe:
    input:  config['references']['GENOME']+".bwt",config['references']['GENOME'], 
            "{x}.R1.fastq",
            "{x}.R2.fastq"
    output: "{x}.sam"
    params: bwa=config['bin']['BWA']
    shell:  config['rules']['map_pe'][pver]

rule sam2bam:
    input:  "{x}.sam"
    output: "{x}.bam"
    shell:  config['rules']['sam2bam'][pver]

rule flagstats:
    input:  "{x}.bam"
    output: "{x}.flags"
    shell:  config['rules']['flagstats'][pver]

rule flagstats_dedup:
    input:  "{x}.dedup.sorted.bam"
    output: "{x}.dedup.flags"
    shell:  config['rules']['flagstats'][pver]

rule coverage_qc:
    input: "{x}"+ext
    output: hist = "{x}.coverage.done"
    shell:  config['rules']['coverage_qc'][pver]

rule sort:
     input:  "{x}.bam"
     output: "{x}.sorted.bam"
     shell:  config['rules']['sort'][pver]

rule markdups:
     input:  "{x}.sorted.{Y}"
     output: out = "{x}.dedup.sorted.{Y}",
             metrics = "{x}.sorted.{Y}.txt"
     params: markdups=config['bin']['MARKDUPS']
     shell:  config['rules']['markdups'][pver]

rule headers:
     input:  "{x}.dedup.{Y}"
     output: "{x}.fin.dedup.{Y}"
     run:  rgid=config['samples'][wildcards.x];rgpl=config['platform'];shell('picard-tools AddOrReplaceReadGroups I={input} O={output} RGID={rgid} RGPL={rgpl} RGLB={rgpl} RGPU={rgpl} RGSM={input} RGCN=Melanoma RGDS={input}')

rule realign:
        input:  "{x}.fin.{Y}"
        output: re="{x}.realign.fin.{Y}",
                int=temp("{x}.fin.{Y}.intervals")
        params: gatk=config['bin']['GATK'],
                genome=config['references']['GENOME'],
                groot=groot,
                indelsites=config['references']['INDELSITES']
        shell:  config['rules']['realign'][pver]

rule recal:
      input:  "{X}.realign.{Y}"
      output: bam="{X}.recal.realign.{Y}",
              re=temp("{X}_recal_data.{Y}.grp"),
              re2=temp("{X}_recal_data2.{Y}.grp"),
              plots="{X}.plots.{Y}.pdf"
      params: gatk=config['bin']['GATK'],
              genome=config['references']['GENOME'],
              indelsites=config['references']['INDELSITES'],
              snpsites=config['references']['SNPSITES']
      shell:  config['rules']['recal'][pver]

rule mpileup:
     input:   "{X}.recal.{Y}"
     output:  "{X}.pileup.recal.{Y}"
     params:  genome=config['references']['GENOME']
     shell: config['rules']['mpileup'][pver]

rule varscan:
       input:  lambda wildcards: config['pairs'][wildcards.x][0]+ext,
               lambda wildcards: config['pairs'][wildcards.x][1]+ext
       output: snp="{x}.snp",
               indel= "{x}.indel",
               snpvcf="{x}.snp.vcf",
               indelvcf="{x}.indel.vcf"
       params: varscan=config['bin']['VARSCAN'],
               snpvcf="{x}.snp",indelvcf="{x}.indel"
       message: "****VARSCAN****"
       shell:  config['rules']['varscan'][pver]


rule annovar:
      input:  snp = "{x}.snp.vcf",
              indel = "{x}.indel.vcf",
      output: snpav = "{x}.snp.vcf.av",
              indelav = "{x}.indel.vcf.av",
      params: snpsum = "{x}.snp.vcf.sum.av",
              indelsum = "{x}.indel.vcf.sum.av",
              annovar1=config['bin']['ANNOVAR1'],
              annovar2=config['bin']['ANNOVAR2'],
              anndir=config['paths']['ANNDIR']
      shell:  config['rules']['annovar'][pver]


rule checkqc:
      input:  "{X}.recal"
      output: cov= "{X}.uniqcov",
              covall = "{X}_covall.txt",
              stat = "{X}_covstat.txt",
              ism = "{X}.insert_size_metrics",
              hist = "{X}_PIChist.pdf",
              flag = "{X}.flagstat.txt",
              tbl="{X}.recal.tbl"
      params: covcalc = config['bin']['COVCALC'],
              covfreq = config['bin']['COVFREQ'],
              gatk=config['bin']['GATK'],
              genome=config['references']['GENOME'],
              picard2=config['bin']['PICARD2'],
              pichist=config['bin']['PICHIST'],
              readdist = config['bin']['READDIST'],
              refflat=config['references']['REFFLAT']
      shell:  config['rules']['checkqc'][pver]
