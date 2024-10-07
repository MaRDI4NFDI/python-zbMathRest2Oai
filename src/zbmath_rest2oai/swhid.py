import csv

def parse_csv_to_dict(csv_file_path):
    swmathid_to_swhid = {}
    with open(csv_file_path, mode='r', newline='', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            swmathid = int(row['swmathid'])
            swhid = row['swhid']
            swmathid_to_swhid[swmathid] = swhid
    return swmathid_to_swhid