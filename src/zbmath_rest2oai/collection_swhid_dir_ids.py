import requests
import re
import pandas as pd

import os
import pandas as pd

# Current script's directory
current_dir = os.path.dirname(os.path.abspath(__file__))

# Navigate up two levels from the 'src/zbmath_rest2oai' directory to the project root
root_dir = os.path.abspath(os.path.join(current_dir, "../../"))

# Construct the desired file path
file_path = os.path.join(root_dir, "test/data/software/swh_swmath.csv")

df = pd.read_csv(file_path)

def get_swhid_dir(snaphot_url):
    req=requests.get(snaphot_url)

    # Decode the byte content to a string (assuming the content is UTF-8 encoded)
    html_content = req.content.decode('utf-8')

    # Use regex to find the object_id (in this case, directory identifier)
    match = re.search(r'swh:1:dir:([a-f0-9]+)', html_content)

    if match:
        object_id = match.group(1)
        print(f"Object ID: {object_id}")
        return "swh:1:dir:"+object_id.split("Object ID: ")[0]
    else:
        print("Object ID not found")
        return 0


list_swhid_dir=list()
for snapshot in df.swhid:
    #print(snapshot)
    #print(snapshot.split("swh:1:snp:"))
    url="https://archive.softwareheritage.org/browse/snapshot/{}/directory/".format(snapshot.split("swh:1:snp:")[1])
    print(url)
    swhid_dir=get_swhid_dir(url)
    list_swhid_dir.append(swhid_dir)


df["swhid_dir"]= list_swhid_dir
df.write(os.path.join(root_dir, "test/data/software/swh_swmath_swhid_dir.csv"))

