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
	zcat ${i} | awk -v file=${i} 'BEGIN{OFS="\t"}NR%4==2{c++; l+=length($0)}END{ print file,c,l}' >> filename_size.dat	
done

total_size=$(awk '{sum+=$3}END{print sum}' filename_size.dat)
undetermined_size=$(grep -i 'undeter' filename_size.dat | awk '{sum+=$3}END{print sum}')
if [ -z "${undetermined_size}" ];then
	undetermined_size=0
fi
net_output=$(echo "scale=2; (${total_size}-${undetermined_size})/10^9" | bc )
echo "Net_output_in_Gb((Total-Undetermined)*151/10^9):${net_output}" >> filename_size.dat
