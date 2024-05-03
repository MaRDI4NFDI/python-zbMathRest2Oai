import sys
import os
sys.path.append(os.getcwd())
from writeLocal import write_local


write_local(api_source='https://api.zbmath.org/v1/software/_all?start_after=0&results_per_request=500')