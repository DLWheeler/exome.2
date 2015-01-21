rule novoalign:
     input:  "{x}.R1.fastq.gz",
             "{x}.R2.fastq.gz"
     output: sam = "{x}.sam",
             qcal = "{x}.qcal"
     params: adapter1=config['constants']['ADAPTER1'],
             adapter2=config['constants']['ADAPTER2'],
             novoindex=config['references']['NOVOINDEX'],
             qcal=config['bin']['QCAL']
     message: "Executing NovoAlign Rule."
     threads: 1
     version: "1.0"
     shell: "module load novocraft; novoalign -c 16 -d {params.novoindex} -a {params.adapter1} {params.adapter2} -H 10 -k -K {output.qcal} -i PE 180,50 -o SAM -f {input} {params.qcal} {output.qcal} {output.qcal}.qcalreport.pdf;" 
