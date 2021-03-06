A = load '/data/pig/filter/data.txt' using PigStorage(',') ; 
B = FILTER A by (((chararray)$0 =='SFAX') or ((chararray)$0 =='TUNIS'));
generatedB = FOREACH B GENERATE (chararray)$0 as depart, (chararray)$1 as destination,(chararray)$2 as avion , (int)$3 as retard;
describe  generatedB ; 
groupby_avion = group generatedB by avion; 
avg_avion = foreach groupby_avion generate group, AVG(generatedB.retard);
STORE avg_avion into '/data/pig/filter/avg' using PigStorage('\t');
retardfiltered= filter generatedB  by retard>20;
groupby_retard = group retardfiltered by avion; 
count_retard =  foreach groupby_retard generate group, COUNT(retardfiltered.retard);
STORE count_retard into '/data/pig/filter/count' using PigStorage('\t');