import sys
import os
sys.path.append(os.getcwd())
from writeLocal import write_local

with open('last_id.txt','r') as f:
write_local(api_source='https://api.zbmath.org/v1/software/_all?start_after=0&results_per_request=500')