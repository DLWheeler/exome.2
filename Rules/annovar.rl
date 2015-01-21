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
      shell:  "{params.annovar1} -format vcf4 {input.snp} -outfile {output.snpav}; {params.annovar1} -format vcf4 {input.indel} -outfile {output.indelav}; {params.annovar2} {output.snpav} {params.anndir} -buildver hg18 -out {params.snpsum} -remove -protocol refGene,knownGene,ensGene -operation g,g,g -nastring NA; {params.annovar2} {output.indelav} {params.anndir} -buildver hg18 -out {params.indelsum} -remove -protocol refGene,knownGene,ensGene -operation g,g,g -nastring NA;"

