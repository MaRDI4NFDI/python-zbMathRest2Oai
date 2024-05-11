import sys
import os
import json
sys.path.append(os.getcwd())

from zbmath_rest2oai import getAsJSON


def write_local(api_source):
    json = getAsJSON.final_json(api_source)
    filename = api_source.split('start_after=')[1].split('&')[0]
    with open('temp_folder_software_metadata/{}.xml'.format(filename), "w") as f:
        json.dump(json,f)
        f.close()

if __name__ == '__main__':
    import sys
    write_local(sys.argv[1])