import sys
import os
sys.path.append(os.getcwd())
from writeLocal import write_local


write_local(api_source='https://api.zbmath.org/v1/software/_search?search_string=si%3A0-100&page=0&results_per_page=100')