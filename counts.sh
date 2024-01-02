#! /bin/bash


#ls *fastq.gz > filelist.log

#for i in `cat filelist.log`
#do
#	output=$(zcat ./${i} | grep "@" | wc -l)
#	echo -e "${i}\t${output}" >> filename_size.dat
#done

#total_size=$(awk '{sum+=$2}END{print sum}' filename_size.dat)
#undermined_size=$(grep -i 'undeter' filename_size.dat | awk '{sum+=$2}END{print sum}')
#net_output=$(echo "((${total_size}-${undermined_size})*151)/1000000000" | bc )

#echo "Total_reads:${total_size}" >> filename_size.dat
#echo "Undertermined_reads:${undermined_size}" >> filename_size.dat
#echo "Net_output_in_Gb((Total-Undetermined)*151/10^9):${net_output}" >> filename_size.dat


for i in `ls *fastq.gz`
do 
	base_count=$(zcat ${i} | paste - - - - | cut -f2 | tr -d '\n' | wc -c)	
	no_of_reads=$(zcat ./${i} | grep "@" | wc -l)
	echo -e "${i}\t${no_of_reads}\t${base_count}" >> zcat_paste.dat
done	
