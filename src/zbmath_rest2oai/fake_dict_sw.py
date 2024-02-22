def fake_dict_sw():
    with open('software.csv','w') as f:
        return f.write("\n".join(map(str,list(range(2, 10)))))

if __name__ == '__main__':
    fake_dict_sw()