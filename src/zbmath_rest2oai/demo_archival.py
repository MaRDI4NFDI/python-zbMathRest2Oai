from zbmath_rest2oai.staging_archival import Swhid
from zbmath_rest2oai.staging_archival import append_archived_url
import os
token = os.getenv('SWH_API_TOKEN')
url="https://github.com/appliedtopology/javaplex"
current_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.abspath(os.path.join(current_dir, "../../"))
archived_file_path = os.path.abspath(os.path.join(root_dir, "test/data/software/swh_swmath_archived.csv"))
print(Swhid(url,token).save_code_now())
