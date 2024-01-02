#!/usr/bin/env bash

path_to_fastq="/samba/NextSeq1000/runs/NAS_data_transfer/190805_M04898_0040_000000000-CK4NB-MIPS/Data/Intensities/BaseCalls"
AML_folder="Miscellaneous-190805"
#AML_folder="CNV_230215"
#AML_folder="211018_ALP"

# Make a folder and copy the fastq.gz files here
mkdir -p ${AML_folder}
#mv ${path_to_fastq}/DrSonaliPatkar*fastq* ${AML_folder}/
#mv ${path_to_fastq}/AlkaWarade*fastq* ${AML_folder}/
#mv ${path_to_fastq}/KNWarade*fastq* ${AML_folder}/

# Copying the data to respective folders needs to be verified
#if [ $? -eq 0 ]; then
#	echo "copied successfully"
#else
#	echo "copying failed"
#fi

# Search for fastq files and choose only the ones without a digit at their start and move them to a folder named in MISC
for i in `ls $path_to_fastq/*fastq* | sed "s:$path_to_fastq/::g" | grep -E '^[^0-9]+' | grep -v 'Undetermined*'`
do
	file_name=$(basename $i)
	echo $file_name $AML_folder
	mv $path_to_fastq/$file_name $AML_folder/
done

exit_stat=1
while [ $exit_stat -ne 0 ]; do
	aws s3 sync ${AML_folder} s3://hematopath-data/Clinical_NGS_Analysis/01FastqArchival2019/${AML_folder}/
	exit_stat=$?
done
echo "`ls ${AML_folder}/*` synced to hematopath-data/Clinical_NGS_Analysis/01FastqArchival2019/${AML_folder}" >> wt_Miscellaneous-190805.dat.info
