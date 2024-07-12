import sys
import os
import json
sys.path.append(os.getcwd())

from zbmath_rest2oai import getAsJSON


def write_local(api_source):
    json_res = getAsJSON.final_json(api_source)
    filename = api_source.split('start_after=')[1].split('&')[0]
    with open('temp_folder_software_metadata/{}.json'.format(filename), "w") as f:
        json.dump(json_res,f)
        f.close()

if __name__ == '__main__':
    write_local(sys.argv[1])

