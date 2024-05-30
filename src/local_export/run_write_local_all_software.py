import sys
import os
sys.path.append(os.getcwd())
from writeLocal import write_local



with open('last_id.txt','r') as f:
    last_id = max(f.read().split(';'))
    f.close()


while int(last_id) < 70000:
    with open('last_id.txt', 'r') as f:
        last_id = str(max([int(x) for x in f.read().split(';')]))
        f.close()
        uri_request = 'https://api.zbmath.org/v1/software/_all?start_after={0}&results_per_request=500'.format(last_id)
        print(uri_request)
        write_local(api_source=uri_request)
