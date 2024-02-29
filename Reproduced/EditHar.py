import os
from os import walk
import json


# folder path
dir_path = r'/home/database/Downloads/StudyofHTTP-main/HARfromReplay'

# list to store files name
res = []
for (dir_path, dir_names, file_names) in walk(dir_path):
    res.extend(file_names)
#print(res[0])


count = 0;

for i in res:
	i = res[count]
	i = i.replace('_com',',')
	i = i.replace('.har','')
	n = i.split(',')
#print(n)

	n[1] = int(n[1])
	n[2] = float(n[2])
	n[3] = int(n[3])

	a_data = {
	     "webName": n[0],
	     "delay": n[1],
    	     "lossRate": n[2],
    	     "bandWidth": n[3]
	}

#print(a_data)


#print(f'/home/database/Downloads/StudyofHTTP-main/HARfromReplay/{n[0]}_com/{res[0]}')


	with open(f'/home/database/Downloads/StudyofHTTP-main/HARfromReplay/{n[0]}_com/{res[count]}','r') as f:
		data = json.load(f)
		data.update(a_data)


	with open(f'/home/database/Downloads/StudyofHTTP-main/HARfromReplay/{n[0]}_com/{res[count]}','w') as f:
		b_data = json.dump(data,f,indent=4)

	count+=1;