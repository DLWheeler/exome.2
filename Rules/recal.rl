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
      shell:  "{params.gatk} -T BaseRecalibrator -I {input} -R {params.genome} -knownSites {params.snpsites} -knownSites {params.indelsites} -o {output.re}; {params.gatk} -T PrintReads -R {params.genome} -I {input} -BQSR {output.re} -o {output.bam}; {params.gatk} -T BaseRecalibrator -I {output.bam} -R {params.genome} -knownSites {params.snpsites} -knownSites {params.indelsites} -BQSR {output.re} -o {output.re2};touch {output.plots}"

