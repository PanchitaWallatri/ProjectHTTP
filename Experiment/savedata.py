import csv
import json
import os
import csv
 
rows = [['id', 'env', 'onContentLoad', 'onLoad', 'url', 'httpVersion', 'cpu', 'ram']]
 
def get_files_in_folder(folder_path):
    files = []
    # Iterate over all files in the folder
    for file_name in os.listdir(folder_path):
        file_path = os.path.join(folder_path, file_name)
        # Check if it's a file
        if os.path.isfile(file_path):
            creation_time = os.path.getctime(file_path)
            files.append([creation_time, file_path])
    sorted_array = sorted(files, key=lambda x: x[0])
    return sorted_array
 
def read_har_file(har_file_path):
    with open(har_file_path, 'r') as har_file:
        har_data = json.load(har_file)
    on_content_load = har_data['log']['pages'][0]['pageTimings']['onContentLoad']
    on_load = har_data['log']['pages'][0]['pageTimings']['onLoad']
    url = har_data['log']['entries'][0]['request']['url']
    http_version = har_data['log']['entries'][0]['request']['httpVersion']
    return [on_content_load, on_load, url, http_version]
 
def read_csv_file(csv_file_path):
    data = []
    with open(csv_file_path, newline='') as csvfile:
        csv_reader = csv.reader(csvfile)
        for column in csv_reader:
            # column[8: cpu, 9: ram]
            data.append([column[8], column[9]])
    transposed_array = list(map(list, zip(*data)))
    result = [sum(map(float, sublist)) for sublist in transposed_array]
    return result
 
for env_num in [1,2,3]:
 
    print('env now:', env_num)
 
    har_dir = f'/home/master-desktop04/Replay/Env{env_num}'
    csv_dir = f'/home/master-desktop04/Resource/Env{env_num}'
 
    # _files[0: time, 1: path]
    har_files = get_files_in_folder(har_dir)
    csv_files = get_files_in_folder(csv_dir)
 
    # check length
    if len(har_files) != len(har_files):
        print(f'>> in env {env_num}, har and csv files didnt the same length')
        print(f'>> len\(har_files\): {len(har_files)}, len\(csv_files\): {len(csv_files)}')
        continue
 
    for i in range(len(har_files)):
        har_info = read_har_file(har_files[i][1])
        csv_info = read_csv_file(csv_files[i][1])
 
        row = [i, env_num] + har_info + csv_info
        rows.append(row)
 
csv_file_name = 'data.csv'
 
# Write the data to a csv file
with open(csv_file_name, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(rows)
 
print(f">> csv file '{csv_file_name}' has been created.")
